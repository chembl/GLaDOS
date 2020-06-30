class TissueReportCardApp extends glados.ReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    super
    tissue = TissueReportCardApp.getCurrentTissue()

    breadcrumbLinks = [
      {
        label: tissue.get('id')
        link: glados.models.Tissue.get_report_card_url(tissue.get('id'))
      }
    ]
    glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks)

    TissueReportCardApp.initBasicInformation()
    TissueReportCardApp.initAssaySummary()
    TissueReportCardApp.initActivitySummary()
    TissueReportCardApp.initAssociatedCompounds()
    tissue.fetch()

  # -------------------------------------------------------------
  # Tissue
  # -------------------------------------------------------------
  @getCurrentTissue = ->

    if not @currentTissue?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentTissue = new glados.models.Tissue
        tissue_chembl_id: chemblID
      return @currentTissue

    else return @currentTissue

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->

    tissue = TissueReportCardApp.getCurrentTissue()

    new TissueBasicInformationView
      model: tissue
      el: $('#TiBasicInformation')
      section_id: 'BasicInformation'
      section_label: 'Basic Information'
      entity_name: glados.models.Tissue.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      tissue.fetch()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedAssays = TissueReportCardApp.getAssociatedAssaysAgg(chemblID)
    associatedAssaysProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Tissue', 'RELATED_ASSAYS')

    pieConfig =
      x_axis_prop_name: 'types'
      title: "ChEMBL Assay Types for Tissue " + chemblID
      title_link_url: Assay.getAssaysListURL('tissue_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: associatedAssaysProp

    viewConfig =
      pie_config: pieConfig
      resource_type: glados.models.Tissue.prototype.entityName
      link_to_all:
        link_text: 'See all assays for tissue ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL('tissue_chembl_id:' + chemblID)
      embed_section_name: 'related_assays'
      embed_identifier: chemblID

    new glados.views.ReportCards.PieInCardView
      model: associatedAssays
      el: $('#TiAssociatedAssaysCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: glados.models.Tissue.prototype.entityName
      report_card_app: @

    associatedAssays.fetch()

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = TissueReportCardApp.getAssociatedBioactivitiesAgg(chemblID)
    bioactivitiesProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Tissue', 'RELATED_ACTIVITIES')

    pieConfig =
      x_axis_prop_name: 'types'
      title: "ChEMBL Activity Types for Tissue " + chemblID
      title_link_url: Activity.getActivitiesListURL('_metadata.assay_data.tissue_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: bioactivitiesProp

    viewConfig =
      pie_config: pieConfig
      resource_type: glados.models.Tissue.prototype.entityName
      embed_section_name: 'bioactivities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all bioactivities for tissue ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('_metadata.assay_data.tissue_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: bioactivities
      el: $('#TiAssociatedActivitiesCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: glados.models.Tissue.prototype.entityName
      report_card_app: @

    bioactivities.fetch()

  @initAssociatedCompounds = (chemblID) ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedCompounds = TissueReportCardApp.getAssociatedCompoundsAgg(chemblID)

    histogramConfig =
      big_size: true
      paint_axes_selectors: true
      properties:
        mwt: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
        alogp: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'ALogP')
        psa: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'PSA')
      initial_property_x: 'mwt'
      x_axis_options: ['mwt', 'alogp', 'psa']
      x_axis_min_columns: 1
      x_axis_max_columns: 20
      x_axis_initial_num_columns: 10
      x_axis_prop_name: 'x_axis_agg'
      title: 'Associated Compounds for Tissue ' + chemblID
      title_link_url: Compound.getCompoundsListURL('_metadata.related_tissues.all_chembl_ids:' + chemblID)
      external_title: true
      range_categories: true

    config =
      histogram_config: histogramConfig
      resource_type: glados.models.Tissue.prototype.entityName
      embed_section_name: 'related_compounds'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#TiAssociatedCompoundsCard')
      model: associatedCompounds
      target_chembl_id: chemblID
      config: config
      section_id: 'CompoundSummaries'
      section_label: 'Compound Summaries'
      entity_name: glados.models.Tissue.prototype.entityName
      report_card_app: @


    associatedCompounds.fetch()

  # -------------------------------------------------------------
  # Aggregations
  # -------------------------------------------------------------
  @getAssociatedAssaysAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'tissue_chembl_id:{{tissue_chembl_id}}'
      template_data:
        tissue_chembl_id: 'tissue_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.assay_generated.type_label'
          size: 20
          bucket_links:

            bucket_filter_template: 'tissue_chembl_id:{{tissue_chembl_id}} ' +
                                    'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              tissue_chembl_id: 'tissue_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Assay.getAssaysListURL

    associatedAssays = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ASSAY_INDEX_URL
      query_config: queryConfig
      tissue_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedAssays

  @getAssociatedBioactivitiesAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '_metadata.assay_data.tissue_chembl_id:{{tissue_chembl_id}}'
      template_data:
        tissue_chembl_id: 'tissue_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.assay_data.tissue_chembl_id:{{tissue_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              tissue_chembl_id: 'tissue_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      tissue_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities

  @getAssociatedCompoundsAgg = (chemblID, minCols=1, maxCols=20, defaultCols=10) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'tissue_chembl_id'
      fields: ['_metadata.related_tissues.all_chembl_ids']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: minCols
          max_columns: maxCols
          num_columns: defaultCols
          bucket_links:
            bucket_filter_template: '_metadata.related_tissues.all_chembl_ids:{{tissue_chembl_id}} ' +
              'AND molecule_properties.full_mwt:(>={{min_val}} AND <={{max_val}})'
            template_data:
              tissue_chembl_id: 'tissue_chembl_id'
              min_val: 'BUCKET.from'
              max_val: 'BUCKETS.to'
            link_generator: Compound.getCompoundsListURL

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      tissue_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedCompounds
  # --------------------------------------------------------------------------------------------------------------------
  # Mini histograms
  # --------------------------------------------------------------------------------------------------------------------
  @initMiniActivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = TissueReportCardApp.getAssociatedBioactivitiesAgg(chemblID)

    stdTypeProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Activity', 'STANDARD_TYPE',
      withColourScale=true)

    barsColourScale = stdTypeProp.colourScale

    config =
      max_categories: 8
      bars_colour_scale: barsColourScale
      fixed_bar_width: true
      hide_title: false
      x_axis_prop_name: 'types'
      properties:
        std_type: stdTypeProp
      initial_property_x: 'std_type'

    new glados.views.Visualisation.HistogramView
      model: bioactivities
      el: $containerElem
      config: config

    bioactivities.fetch()

  @initMiniCompoundsHistogram = ($containerElem, chemblID) ->

    associatedCompounds = TissueReportCardApp.getAssociatedCompoundsAgg(chemblID, minCols=8,
      maxCols=8, defaultCols=8)

    config =
      max_categories: 8
      fixed_bar_width: true
      hide_title: false
      x_axis_prop_name: 'x_axis_agg'
      properties:
        mwt: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound', 'FULL_MWT')
      initial_property_x: 'mwt'

    new glados.views.Visualisation.HistogramView
      model: associatedCompounds
      el: $containerElem
      config: config

    associatedCompounds.fetch()

  @initMiniHistogramFromFunctionLink = ->
    $clickedLink = $(@)

    [paramsList, constantParamsList, $containerElem] = \
    glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell($clickedLink)

    histogramType = constantParamsList[0]
    chemblID = paramsList[0]

    if histogramType == 'activities'
      TissueReportCardApp.initMiniActivitiesHistogram($containerElem, chemblID)
    else if histogramType == 'compounds'
      TissueReportCardApp.initMiniCompoundsHistogram($containerElem, chemblID)
