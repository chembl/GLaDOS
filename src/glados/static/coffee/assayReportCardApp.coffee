class AssayReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->

    assay = AssayReportCardApp.getCurrentAssay()
    AssayReportCardApp.initAssayBasicInformation()
    AssayReportCardApp.initCurationSummary()
    AssayReportCardApp.initActivitySummary()

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
