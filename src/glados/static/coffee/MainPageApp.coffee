# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

# ----------------------------------------------------------------------------------------------------------------------
# Initialization
# ----------------------------------------------------------------------------------------------------------------------

  @init = ->
    glados.apps.Main.MainGladosApp.hideMainSplashScreen()

    new glados.views.MainPage.VisualisationsWithCaptionsView
      el: $('.BCK-visualisations-with-captions')

    @initAssociatedResources()
    @initDatabaseSummary()
    @initTweets()
    @initBlogEntries()
    @initGithubDetails()

# ----------------------------------------------------------------------------------------------------------------------
# Init functions
# ----------------------------------------------------------------------------------------------------------------------
  @initTargetClassificationSunburst = ($browseButtonContainer) ->

    config =
      browse_all_link: "#{glados.Settings.GLADOS_BASE_URL_FULL}/g/#browse/targets"
      browse_button: true
      browse_button_container: $browseButtonContainer
      entity_name_plural: Target.prototype.entityNamePlural

    view = new glados.views.MainPage.TargetClassificationsSunburstsView
      el: $('#BCK-protein-classification-zoomburst')
      config: config

    return view

  @initAssayClassificationSunburst = ($browseButtonContainer) ->

    config =
      browse_all_link: "#{glados.Settings.GLADOS_BASE_URL_FULL}/g/#browse/assays"
      browse_button: true
      browse_button_container: $browseButtonContainer
      entity_name_plural: Assay.prototype.entityNamePlural

    view = new glados.views.MainPage.AssayClassificationsSunburstsView
      el: $('#BCK-assay-classification-zoomburst')
      config: config

    return view

  @initBrowseEntities = ->
    return new glados.views.MainPage.BrowseEntitiesAsCirclesView
      el: $('#BrowseEntitiesAsCircles')

  @initMaxPhaseForDisease = ->
    maxPhaseForDisease = MainPageApp.getMaxPhaseForDiseaseAgg()
    maxPhaseProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'MAX_PHASE', true)
    diseaseClassProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'DISEASE')

    pieConfig =
      side_legend: true
      x_axis_prop_name: 'maxPhaseForDisease'
      split_series_prop_name: 'split_series_agg'
      title: 'Max Phase for Disease'
      max_categories: 5
      stacked_donut: true
      stacked_levels: 2
      hide_title: true
      properties:
        max_phase: maxPhaseProp
        disease_class: diseaseClassProp
      initial_property_x: 'max_phase'
      initial_property_z: 'disease_class'
      title_link_url: Drug.getDrugsListURL()

    config =
      pie_config: pieConfig
      is_outside_an_entity_report_card: true
      disable_embedding: true
      embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#max_phase_for_disease"
      view_name: 'Visualisation-DrugsByMaxPhaseAndDisease'
      view_type: glados.views.base.TrackView.viewTypes.VISUALISATION
      link_to_all:
        link_text: 'See all drug Compounds in ChEMBL'
        url: Drug.getDrugsListURL()

    view = new glados.views.ReportCards.PieInCardView
      el: $('#MaxPhaseForDisease')
      model: maxPhaseForDisease
      config: config
      report_card_app: @

    maxPhaseForDisease.fetch()
    return view

  @initFirstApprovalByMoleculeType = ->
    drugsByMoleculeTypeAgg = MainPageApp.getFirstApprovalPercentage()

    approvalDateProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FIRST_APPROVAL')
    moleculeTypeProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'MOLECULE_TYPE', true)
    barsColourScale = moleculeTypeProp.colourScale

    histogramConfig =
      bars_colour_scale: barsColourScale
      stacked_histogram: true
      sort_by_key: false
      rotate_x_axis_if_needed: true
      hide_x_axis_title: true
      legend_vertical: true
      big_size: true
      paint_axes_selectors: true
      properties:
        year: approvalDateProp
        molecule_type: moleculeTypeProp
      initial_property_x: 'year'
      initial_property_z: 'molecule_type'
      x_axis_options: ['count']
      x_axis_min_columns: 1
      x_axis_max_columns: 40
      x_axis_initial_num_columns: 40
      x_axis_prop_name: 'firstApprovalByMoleculeType'
      y_scale_mode: 'percentage'
      title: 'Drugs By Molecule Type and First Approval'
      title_link_url: Drug.getDrugsListURL('_exists_:first_approval')

    config =
      histogram_config: histogramConfig
      disable_embedding: true
      is_outside_an_entity_report_card: true
      view_name: 'Visualisation-DrugsByMoleculeTypeAndFirstApproval'
      view_type: glados.views.base.TrackView.viewTypes.VISUALISATION
#      embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#documents_by_year_histogram"

    view = new glados.views.ReportCards.HistogramInCardView
      el: $('#BCK-FirstApprovalHistogram')
      model: drugsByMoleculeTypeAgg
      config: config
      report_card_app: @

    drugsByMoleculeTypeAgg.fetch()
    return view

  @initDrugsPerUsanYear = ->

    allDrugsByYear = glados.apps.VisualisePageApp.getYearByMaxPhaseAgg()

    usanYearProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'USAN_YEAR')
    maxPhaseProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'MAX_PHASE', true)
    barsColourScale = maxPhaseProp.colourScale

    histogramConfig =
      bars_colour_scale: barsColourScale
      stacked_histogram: true
      sort_by_key: true
      rotate_x_axis_if_needed: false
      hide_x_axis_title: true
      y_scale_mode: 'normal'
      legend_vertical: true
      big_size: true
      paint_axes_selectors: true
      properties:
        year: usanYearProp
        max_phase: maxPhaseProp
      initial_property_x: 'year'
      initial_property_z: 'max_phase'
      x_axis_options: ['count']
      x_axis_min_columns: 1
      x_axis_max_columns: 40
      x_axis_initial_num_columns: 40
      x_axis_prop_name: 'yearByMaxPhase'
      title: 'Drugs by Usan Year'
      title_link_url: Drug.getDrugsListURL('_metadata.compound_records.src_id:13 AND _exists_:usan_year')

    config =
      histogram_config: histogramConfig
      is_outside_an_entity_report_card: true
      disable_embedding: true
      view_name: 'Visualisation-DrugsByUsanYear'
      view_type: glados.views.base.TrackView.viewTypes.VISUALISATION
#      embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#documents_by_year_histogram"

    view = new glados.views.ReportCards.HistogramInCardView
      el: $('#PapersPerYearHistogram')
      model: allDrugsByYear
      config: config
      report_card_app: @

    allDrugsByYear.fetch()

    return view

  @initTargetsVisualisation = ($browseButtonContainer) ->

    targetHierarchyAgg = MainPageApp.getTargetsOrganismTreeAgg()

    config =
      is_outside_an_entity_report_card: true
      disable_embedding: true
      embed_url: "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/#targets_by_protein_class"
      view_class: BrowseTargetAsCirclesView
      view_name: 'Visualisation-TargetBrowserAsCircles'
      view_type: glados.views.base.TrackView.viewTypes.VISUALISATION
      view_config:
        browse_button_container: $browseButtonContainer

    view = new glados.views.ReportCards.VisualisationInCardView
      el: $('#BCK-TargetBrowserAsCircles')
      model: targetHierarchyAgg
      config: config
      report_card_app: @

    targetHierarchyAgg.fetch()
    return view

  @initDatabaseSummary = ->
    databaseInfo = new glados.models.MainPage.DatabaseSummaryInfo()
    new glados.views.MainPage.DatabaseSummaryView
      model: databaseInfo
      el: $('.BCK-Database-summary-info')
    databaseInfo.fetch()

  @initAssociatedResources = ->
    new glados.views.MainPage.AssociatedResourcesView
      el: $('.BCK-Associated-resources')

  @initTweets = ->
    tweetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    tweetsList.initURL()
    $tweetsElem = $('.BCK-Tweets-container')
    glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(tweetsList, $tweetsElem, 'do-repaint')
    tweetsList.fetch()

  @initBlogEntries = ->
    blogEntriesList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBlogEntriesList()
    blogEntriesList.initURL()
    $blogEntriesElem = $('.BCK-Blog-Entries-container')
    glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(blogEntriesList, $blogEntriesElem, 'do-repaint')
    blogEntriesList.fetch()

  @initGithubDetails = ->
    new glados.views.MainPage.GitHubDetailsView
      el: $('.BCK-github-details')

# ----------------------------------------------------------------------------------------------------------------------
# Aggregations
# ----------------------------------------------------------------------------------------------------------------------

  @getFirstApprovalPercentage = (defaultInterval = 1) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '_metadata.drug.is_drug:true'
      template_data: {}

    aggsConfig =
      aggs:
        firstApprovalByMoleculeType:
          type: glados.models.Aggregations.Aggregation.AggTypes.HISTOGRAM
          field: 'first_approval'
          default_interval_size: defaultInterval
          min_interval_size: 1
          max_interval_size: 10
          bucket_key_parse_function: (key) -> key.replace(/\.0/i, '')
          bucket_sort_compare_function: (bucketA, bucketB) ->
            yearA = parseFloat(bucketA.key)
            yearB = parseFloat(bucketB.key)
            if yearA < yearB
              return -1
            else if yearA > yearB
              return 1
            return 0
          aggs:
            molecule_type:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: 'molecule_type'
              size: 10
              bucket_links:
                bucket_filter_template: 'first_approval:{{year}} AND molecule_type:"{{bucket_key}}"'
                template_data:
                  year: 'BUCKET.parsed_parent_key'
                  bucket_key: 'BUCKET.key'

                link_generator: Drug.getDrugsListURL

    moleculeTypeByYear = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return moleculeTypeByYear

  @getMaxPhaseForDiseaseAgg = () ->
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '_metadata.drug.is_drug:true'
      template_data: {}

    aggsConfig =
      aggs:
        maxPhaseForDisease:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'max_phase'
          size: 5
          bucket_links:
            bucket_filter_template: '_metadata.drug.is_drug:true AND ' +
              'max_phase:{{bucket_key}}'
            template_data:
              bucket_key: 'BUCKET.key'

            link_generator: Compound.getCompoundsListURL
          aggs:
            split_series_agg:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: '_metadata.drug_indications.efo_term'
              size: 12
              bucket_links:
                bucket_filter_template: '_metadata.drug.is_drug:true AND ' +
                  'max_phase :{{max_phase}} AND _metadata.drug_indications.efo_term:("{{bucket_key}}"' +
                  '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
                template_data:
                  max_phase: 'BUCKET.parent_key'
                  bucket_key: 'BUCKET.key'
                  extra_buckets: 'EXTRA_BUCKETS.key'

                link_generator: Compound.getCompoundsListURL

    MaxPhaseForDisease = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return MaxPhaseForDisease

  @getTargetsOrganismTreeAgg = ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'
      template_data: {}

    aggsConfig =
      aggs:
        children:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.organism_taxonomy.l1'
          size: 50
          bucket_links:
            bucket_filter_template: '_metadata.organism_taxonomy.l1:("{{bucket_key}}")'
            template_data:
              bucket_key: 'BUCKET.key'
            link_generator: Target.getTargetsListURL
          aggs:
            children:
              type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
              field: '_metadata.organism_taxonomy.l2'
              size: 50
              bucket_links:
                bucket_filter_template: '_metadata.organism_taxonomy.l2:("{{bucket_key}}")'
                template_data:
                  bucket_key: 'BUCKET.key'
                link_generator: Target.getTargetsListURL
              aggs:
                children:
                  type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
                  field: '_metadata.organism_taxonomy.l3'
                  size: 50
                  bucket_links:
                    bucket_filter_template: '_metadata.organism_taxonomy.l3:("{{bucket_key}}")'
                    template_data:
                      bucket_key: 'BUCKET.key'
                    link_generator: Target.getTargetsListURL

    organismTreeAgg = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return organismTreeAgg
