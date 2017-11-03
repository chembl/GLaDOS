class TissueReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    TissueReportCardApp.initAssaySummary()
    
    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedAssays = TissueReportCardApp.getAssociatedAssaysAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_tissue__associated_assays_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_tissue_name')
      link_to_all:
        link_text: 'See all assays for tissue ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL('tissue_chembl_id:' + chemblID)
      embed_section_name: 'related_assays'
      embed_identifier: chemblID

    new glados.views.ReportCards.PieInCardView
      model: associatedAssays
      el: $('#TiAssociatedAssaysCard')
      config: viewConfig

    associatedAssays.fetch()

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
          field: 'assay_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'tissue_chembl_id:{{tissue_chembl_id}} ' +
                                    'AND assay_type:("{{bucket_key}}"' +
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
