class CellLineReportCardApp extends glados.ReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    super
    cellLine = CellLineReportCardApp.getCurrentCellLine()

    breadcrumbLinks = [
      {
        label: cellLine.get('id')
        link: CellLine.get_report_card_url(cellLine.get('id'))
      }
    ]
    glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks)

    CellLineReportCardApp.initBasicInformation()
    CellLineReportCardApp.initAssaySummary()
    CellLineReportCardApp.initActivitySummary()
    CellLineReportCardApp.initAssociatedCompounds()
    cellLine.fetch()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentCellLine = ->

    if not @currentCellLine?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentCellLine = new CellLine
        cell_chembl_id: chemblID
      return @currentCellLine

    else return @currentCellLine

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->

    cellLine = CellLineReportCardApp.getCurrentCellLine()

    new CellLineBasicInformationView
      model: cellLine
      el: $('#CBasicInformation')
      section_id: 'BasicInformation'
      section_label: 'Basic Information'
      entity_name: CellLine.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      cellLine.fetch()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedAssays = CellLineReportCardApp.getAssociatedAssaysAgg(chemblID)
    associatedAssaysProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Cell', 'RELATED_ASSAYS')

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_cell_line__associated_assays_pie_title_base') + chemblID
      title_link_url: Assay.getAssaysListURL('cell_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: associatedAssaysProp

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_cell_line_name')
      link_to_all:
        link_text: 'See all assays for cell line ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL('cell_chembl_id:' + chemblID)
      embed_section_name: 'related_assays'
      embed_identifier: chemblID

    new glados.views.ReportCards.PieInCardView
      model: associatedAssays
      el: $('#CAssociatedAssaysCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: CellLine.prototype.entityName
      report_card_app: @

    associatedAssays.fetch()


  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = CellLineReportCardApp.getAssociatedBioactivitiesAgg(chemblID)
    bioactivitiesProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Cell', 'RELATED_ACTIVITIES')

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_cell_line__bioactivities_pie_title_base') + chemblID
      title_link_url: Activity.getActivitiesListURL('_metadata.assay_data.cell_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: bioactivitiesProp

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_cell_line_name')
      embed_section_name: 'bioactivities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all bioactivities for cell line ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('_metadata.assay_data.cell_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: bioactivities
      el: $('#CLAssociatedActivitiesCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: CellLine.prototype.entityName
      report_card_app: @

    bioactivities.fetch()

  @initAssociatedCompounds = (chemblID) ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedCompounds = CellLineReportCardApp.getAssociatedCompoundsAgg(chemblID)

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
      title: 'Associated Compounds for Cell Line ' + chemblID
      title_link_url: Compound.getCompoundsListURL('_metadata.related_cell_lines.all_chembl_ids:' + chemblID)
      external_title: true
      range_categories: true

    config =
      histogram_config: histogramConfig
      resource_type: gettext('glados_entities_cell_line_name')
      embed_section_name: 'related_compounds'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#CLAssociatedCompoundProperties')
      model: associatedCompounds
      target_chembl_id: chemblID
      config: config
      section_id: 'CompoundSummaries'
      section_label: 'Compound Summaries'
      entity_name: CellLine.prototype.entityName
      report_card_app: @

    associatedCompounds.fetch()

  # -------------------------------------------------------------
  # Aggregations
  # -------------------------------------------------------------
  @getAssociatedAssaysAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'cell_chembl_id:{{cell_chembl_id}}'
      template_data:
        cell_chembl_id: 'cell_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.assay_generated.type_label'
          size: 20
          bucket_links:

            bucket_filter_template: 'cell_chembl_id:{{cell_chembl_id}} ' +
                                    'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              cell_chembl_id: 'cell_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Assay.getAssaysListURL

    associatedAssays = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ASSAY_INDEX_URL
      query_config: queryConfig
      cell_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedAssays

  @getAssociatedBioactivitiesAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '_metadata.assay_data.cell_chembl_id:{{cell_chembl_id}}'
      template_data:
        cell_chembl_id: 'cell_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.assay_data.cell_chembl_id:{{cell_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              cell_chembl_id: 'cell_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      cell_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities

  @getAssociatedCompoundsAgg = (chemblID, minCols=1, maxCols=20, defaultCols=10) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'cell_chembl_id'
      fields: ['_metadata.related_cell_lines.chembl_ids.*']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: minCols
          max_columns: maxCols
          num_columns: defaultCols
          bucket_links:
            bucket_filter_template: '_metadata.related_cell_lines.all_chembl_ids:{{cell_chembl_id}} ' +
              'AND molecule_properties.full_mwt:(>={{min_val}} AND <={{max_val}})'
            template_data:
              cell_chembl_id: 'cell_chembl_id'
              min_val: 'BUCKET.from'
              max_val: 'BUCKETS.to'
            link_generator: Compound.getCompoundsListURL

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      cell_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedCompounds

  # --------------------------------------------------------------------------------------------------------------------
  # Mini histograms
  # --------------------------------------------------------------------------------------------------------------------
  @initMiniActivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = CellLineReportCardApp.getAssociatedBioactivitiesAgg(chemblID)

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

    associatedCompounds = CellLineReportCardApp.getAssociatedCompoundsAgg(chemblID, minCols=8,
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
      CellLineReportCardApp.initMiniActivitiesHistogram($containerElem, chemblID)
    else if histogramType == 'compounds'
      CellLineReportCardApp.initMiniCompoundsHistogram($containerElem, chemblID)
