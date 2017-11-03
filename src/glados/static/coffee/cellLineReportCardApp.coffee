class CellLineReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    cellLine = CellLineReportCardApp.getCurrentCellLine()
    CellLineReportCardApp.initBasicInformation()
    CellLineReportCardApp.initAssaySummary()
    CellLineReportCardApp.initActivitySummary()
    cellLine.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

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

    if GlobalVariables['EMBEDED']
      cellLine.fetch()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedAssays = CellLineReportCardApp.getAssociatedAssaysAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_cell_line__associated_assays_pie_title_base') + chemblID

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

    associatedAssays.fetch()


  @initActivitySummary = ->

    #TODO: update when index is ready
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = CellLineReportCardApp.getAssociatedBioactivitiesAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_cell_line__bioactivities_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_cell_line_name')
      embed_section_name: 'bioactivities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all bioactivities for cell line ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL()

    new glados.views.ReportCards.PieInCardView
      model: bioactivities
      el: $('#CLAssociatedActivitiesCard')
      config: viewConfig

    bioactivities.fetch()


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
          field: 'assay_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'cell_chembl_id:{{cell_chembl_id}} ' +
                                    'AND assay_type:("{{bucket_key}}"' +
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

    #TODO: check how to get in index
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      cell_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities
