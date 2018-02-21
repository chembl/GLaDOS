# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    new glados.views.MainPage.CentralCardView
      el: $('.BCK-Central-Card')

    databaseInfo = new glados.models.MainPage.DatabaseSummaryInfo()

    new glados.views.MainPage.DatabaseSummaryView
      model: databaseInfo
      el: $('.BCK-Database-summary-info')

    databaseInfo.fetch()

    tweetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    tweetsList.initURL()
    $tweetsElem = $('.BCK-Tweets-container')
    glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(tweetsList, $tweetsElem, 'do-repaint')

    tweetsList.fetch()

    MainPageApp.initPapersPerYear()

    targetsHierarchyAgg = MainPageApp.getTargetsTreeAgg()
    targetsHierarchyAgg.fetch()
    #initialize browser targets viz
    targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
    targetBrowserView = TargetBrowserApp.initBrowserAsCircles(targetHierarchy, $('#BCK-TargetBrowserAsCircles'))
    targetHierarchy.fetch()

# ---------------- Aggregation -------------- #
  @getDocumentsPerYearAgg = (defaultInterval=1) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'
      template_data: {}

    aggsConfig =
      aggs:
        documentsPerYear:
          type: glados.models.Aggregations.Aggregation.AggTypes.HISTOGRAM
          field: 'year'
          default_interval_size: defaultInterval
          min_interval_size: 1
          max_interval_size: 10
          aggs:
            split_series_agg:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: 'journal'
              size: 10
              bucket_links:

                bucket_filter_template: 'year:{{year}} AND journal:("{{bucket_key}}"' +
                                        '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
                template_data:
                  year: 'BUCKET.parent_key'
                  bucket_key: 'BUCKET.key'
                  extra_buckets: 'EXTRA_BUCKETS.key'

                link_generator: Document.getDocumentsListURL

    allDocumentsByYear = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.DOCUMENT_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return allDocumentsByYear


  @getTargetsTreeAgg = ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'
      template_data: {}

    aggsConfig =
      aggs:
        l1_class:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.protein_classification.l1'
          size: 100
          bucket_links:
            bucket_filter_template: '_metadata.protein_classification.l1:("{{bucket_key}}")'
            template_data:
              bucket_key: 'BUCKET.key'
            link_generator: Target.getTargetsListURL
          aggs:
            l2_class:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: '_metadata.protein_classification.l2'
              size: 100
              bucket_links:
                bucket_filter_template: '_metadata.protein_classification.l2:("{{bucket_key}}")'
                template_data:
                  bucket_key: 'BUCKET.key'
                link_generator: Target.getTargetsListURL


    targetsTreeAgg = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return targetsTreeAgg



  @initPapersPerYear = ->

    allDocumentsByYear = MainPageApp.getDocumentsPerYearAgg()
    yearProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('DocumentAggregation',
      'YEAR')
    journalNameProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('DocumentAggregation',
      'JOURNAL_NAME')
    barsColourScale = journalNameProp.colourScale

    histogramConfig =
      bars_colour_scale: barsColourScale
      stacked_histogram: true
      rotate_x_axis_if_needed: false
      legend_vertical: true
      big_size: true
      paint_axes_selectors: true
      properties:
        year: yearProp
        journal: journalNameProp
      initial_property_x: 'year'
      initial_property_z: 'journal'
      x_axis_options: ['count']
      x_axis_min_columns: 1
      x_axis_max_columns: 40
      x_axis_initial_num_columns: 40
      x_axis_prop_name: 'documentsPerYear'
      title: 'Documents by Year'
      title_link_url: Document.getDocumentsListURL()
      max_z_categories: 7
      title_link_url: Document.getDocumentsListURL()

    config =
      histogram_config: histogramConfig
      is_outside_an_entity_report_card: true
      embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#documents_by_year_histogram"

    new glados.views.ReportCards.HistogramInCardView
      el: $('#PapersPerYearHistogram')
      model: allDocumentsByYear
      config: config
      report_card_app: @

    allDocumentsByYear.fetch()

