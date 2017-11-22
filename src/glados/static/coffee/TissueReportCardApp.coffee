class TissueReportCardApp extends glados.ReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    super
    TissueReportCardApp.initAssaySummary()
    TissueReportCardApp.initActivitySummary()
    TissueReportCardApp.initAssociatedCompounds()

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
      section_id: 'AssaySummary'
      section_label: 'Assay Summary'
      report_card_app: @

    associatedAssays.fetch()

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = TissueReportCardApp.getAssociatedBioactivitiesAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_tissue__bioactivities_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_tissue_name')
      embed_section_name: 'bioactivities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all bioactivities for tissue ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('_metadata.assay_data.tissue_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: bioactivities
      el: $('#TiAssociatedActivitiesCard')
      config: viewConfig
      section_id: 'BioactivitySummary'
      section_label: 'Activity Summary'
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
      title_link_url: Compound.getCompoundsListURL('_metadata.related_tissues.chembl_ids.\\*:' + chemblID)
      range_categories: true

    config =
      histogram_config: histogramConfig
      resource_type: gettext('glados_entities_tissue_name')
      embed_section_name: 'related_compounds'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#TiAssociatedCompoundsCard')
      model: associatedCompounds
      target_chembl_id: chemblID
      config: config
      section_id: 'CompoundSummaries'
      section_label: 'Compound Summaries'
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

  @getAssociatedCompoundsAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'tissue_chembl_id'
      fields: ['_metadata.related_tissues.chembl_ids.*']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: 1
          max_columns: 20
          num_columns: 10
          bucket_links:
            bucket_filter_template: '_metadata.related_tissues.chembl_ids.\\*:{{tissue_chembl_id}} ' +
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