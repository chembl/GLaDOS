class AssayReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    assay = AssayReportCardApp.getCurrentAssay()
    AssayReportCardApp.initAssayBasicInformation()
    AssayReportCardApp.initCurationSummary()
    AssayReportCardApp.initActivitySummary()
    AssayReportCardApp.initAssociatedCompounds()

    assay.fetch()

    $('.scrollspy').scrollSpy();
    ScrollSpyHelper.initializeScrollSpyPinner();

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initAssayBasicInformation = ->

    assay = AssayReportCardApp.getCurrentAssay()

    new AssayBasicInformationView
      model: assay
      el: $('#ABasicInformation')

    if GlobalVariables['EMBEDED']
      assay.fetch()

  @initCurationSummary = ->

    target = new Target
      assay_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new AssayCurationSummaryView
      model: target
      el: $('#ACurationSummaryCard')

    target.fetchFromAssayChemblID();

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = AssayReportCardApp.getAssociatedBioactivitiesAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_assay__associated_activities_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_assay_name')
      embed_section_name: 'bioactivities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all bioactivities for assay ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('assay_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: bioactivities
      el: $('#AAssociatedBioactivitiesCard')
      config: viewConfig

    bioactivities.fetch()

  @initAssociatedCompounds = ->

    #TODO: UPDATE WHEN AGG IS READY
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedCompounds = AssayReportCardApp.getAssociatedCompoundsAgg(chemblID)

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
      title: 'Associated Compounds for Assay ' + chemblID
      title_link_url: Compound.getCompoundsListURL()
      range_categories: true

    config =
      histogram_config: histogramConfig
      resource_type: 'Assay'
      embed_section_name: 'associated_compounds'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#AAssociatedCompoundProperties')
      model: associatedCompounds
      target_chembl_id: chemblID
      config: config

    associatedCompounds.fetch()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentAssay = ->

    if not @currentAssay?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentAssay = new Assay
        assay_chembl_id: chemblID
      return @currentAssay

    else return @currentAssay

  # --------------------------------------------------------------------------------------------------------------------
  # Aggregations
  # --------------------------------------------------------------------------------------------------------------------
  @getAssociatedBioactivitiesAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'assay_chembl_id:{{assay_chembl_id}}'
      template_data:
        assay_chembl_id: 'assay_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'assay_chembl_id:{{assay_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              assay_chembl_id: 'assay_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      assay_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities

  @getAssociatedCompoundsAgg = (chemblID, minCols=1, maxCols=20, defaultCols=10) ->

    #TODO use proper parameters when index is ready
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: 1
          max_columns: 20
          num_columns: 10
          bucket_links:
            bucket_filter_template: 'molecule_properties.full_mwt:(>={{min_val}} AND <={{max_val}})'
            template_data:
              min_val: 'BUCKET.from'
              max_val: 'BUCKETS.to'
            link_generator: Compound.getCompoundsListURL

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      target_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedCompounds
