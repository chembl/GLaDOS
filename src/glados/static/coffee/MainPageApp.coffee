# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    new glados.views.MainPage.CentralCardView
      el: $('.BCK-Central-Card')

    databaseInfo = new glados.models.MainPage.DatabaseSummaryInfo()
    console.log 'databaseInfo: ', databaseInfo
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

    #initialize browser targets viz
#    targetHierarchy = TargetBrowserApp.initTargetHierarchyTree()
#    targetBrowserView = TargetBrowserApp.initBrowserMain(targetHierarchy, $('#BCK-TargetBrowserMain'))
#    targetHierarchy.fetch()
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

    config =
      histogram_config: histogramConfig
      is_entity_report_card: false
      resource_type: 'Target'
      embed_section_name: 'associated_compounds'
      embed_identifier: 'CHEMBL1'

    new glados.views.ReportCards.HistogramInCardView
      el: $('#PapersPerYearHistogram')
      model: allDocumentsByYear
      target_chembl_id: 'CHEMBL1'
      config: config
      report_card_app: @

    new glados.views.Visualisation.HistogramView
      el: $('.BCK-MainHistogramContainer')
      config: histogramConfig
      model: allDocumentsByYear


    allDocumentsByYear.fetch()

