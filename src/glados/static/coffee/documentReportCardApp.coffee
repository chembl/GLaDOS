class DocumentReportCardApp extends glados.ReportCardApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    super
    document = DocumentReportCardApp.getCurrentDocument()

    DocumentReportCardApp.initBasicInformation()
    DocumentReportCardApp.initRelatedDocuments()
    DocumentReportCardApp.initWordCloud()
    DocumentReportCardApp.initAssayNetwork()
    DocumentReportCardApp.initTargetSummary()
    DocumentReportCardApp.initAssaySummary()
    DocumentReportCardApp.initActivitySummary()
    DocumentReportCardApp.initCompoundSummary()

    document.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentDocument = ->

    if not @currentDocument?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentDocument = new Document
        document_chembl_id: chemblID
      return @currentDocument

    else return @currentDocument

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initBasicInformation = ->

    document = DocumentReportCardApp.getCurrentDocument()

    new DocumentBasicInformationView
      model: document
      el: $('#DBasicInformation')
      section_id: 'BasicInformation'
      section_label: 'Basic Information'
      report_card_app: @

    if GlobalVariables['EMBEDED']
      document.fetch()

  @initRelatedDocuments = ->

    @registerSection('RelatedDocuments', 'Related Documents')
    @showSection('RelatedDocuments')

  @initAssayNetwork = ->

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentAssayNetworkView
      model: documentAssayNetwork
      el: $('#DAssayNetworkCard')
      section_id: 'AssayNetwork'
      section_label: 'Assay Network'
      report_card_app: @

    documentAssayNetwork.fetch()

  @initWordCloud = ->

    docTerms = new DocumentTerms
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentWordCloudView
      model: docTerms
      el: $('#DWordCloudCard')
      section_id: 'WordCloud'
      section_label: 'Word Cloud'
      report_card_app: @

    docTerms.fetch()

  @initTargetSummary = ->

    #TODO: update when index is ready
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedTargets = DocumentReportCardApp.getRelatedTargetsAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_document__associated_targets_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_document_name')
      embed_section_name: 'related_targets'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all targets related to ' + chemblID + ' used in this visualisation.'
        url: Target.getTargetsListURL('_metadata.related_documents.chembl_ids.\\*:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: relatedTargets
      el: $('#DAssociatedTargetsCard')
      config: viewConfig
      section_id: 'ProteinTargetSummay'
      section_label: 'Target Summay'
      report_card_app: @

    relatedTargets.fetch()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedAssays = DocumentReportCardApp.getRelatedAssaysAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_document__associated_assays_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_document_name')
      embed_section_name: 'related_assays'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all assays related to ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL('document_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: relatedAssays
      el: $('#DAssociatedAssaysCard')
      config: viewConfig
      section_id: 'AssaySummary'
      section_label: 'Assay Summary'
      report_card_app: @

    relatedAssays.fetch()

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedActivities = DocumentReportCardApp.getRelatedActivitiesAgg(chemblID)

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_document__associated_activities_pie_title_base') + chemblID

    viewConfig =
      pie_config: pieConfig
      resource_type: gettext('glados_entities_document_name')
      embed_section_name: 'related_activities'
      embed_identifier: chemblID
      link_to_all:
        link_text: 'See all activities related to ' + chemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('document_chembl_id:' + chemblID)

    new glados.views.ReportCards.PieInCardView
      model: relatedActivities
      el: $('#DAssociatedActivitiesCard')
      config: viewConfig
      section_id: 'BioactivitySummary'
      section_label: 'Activity Summary'
      report_card_app: @

    relatedActivities.fetch()


  @initCompoundSummary = ->

    # TODO: update after index is updated https://github.com/chembl/GLaDOS-es/issues/8
    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedCompounds = DocumentReportCardApp.getAssociatedCompoundsAgg(chemblID)

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
      title: 'Associated Compounds for Document ' + chemblID
      title_link_url: Compound.getCompoundsListURL()
      range_categories: true

    config =
      histogram_config: histogramConfig
      resource_type: gettext('glados_entities_document_name')
      embed_section_name: 'related_compounds'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#DAssociatedCompoundPropertiesCard')
      model: associatedCompounds
      document_chembl_id: chemblID
      config: config
      section_id: 'CompoundSummaries'
      section_label: 'Compound Summaries'
      report_card_app: @


    associatedCompounds.fetch()



  # -------------------------------------------------------------
  # Full Screen views
  # -------------------------------------------------------------
  @initAssayNetworkFS = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: GlobalVariables.CHEMBL_ID

    danFSView = new DocumentAssayNetworkFSView
      model: documentAssayNetwork
      el: $('#DAN-Main')

    documentAssayNetwork.fetch()

  # -------------------------------------------------------------
  # Aggregations
  # -------------------------------------------------------------
  @getRelatedTargetsAgg = (chemblID) ->

    #TODO: use the target class when it the mapping is ready https://github.com/chembl/GLaDOS-es/issues/15
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'document_chembl_id'
      fields: ['_metadata.related_documents.chembl_ids.*']

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'target_type'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.related_documents.chembl_ids.\\*:{{document_chembl_id}} ' +
                                    'AND target_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              document_chembl_id: 'document_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Target.getTargetsListURL

    targetTypes = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      document_chembl_id: chemblID
      aggs_config: aggsConfig

    return targetTypes

  @getRelatedAssaysAgg = (chemblID) ->

    #TODO: update when label for type is in index
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'document_chembl_id:{{document_chembl_id}}'
      template_data:
        document_chembl_id: 'document_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.assay_generated.type_label'
          size: 20
          bucket_links:

            bucket_filter_template: 'document_chembl_id:{{document_chembl_id}} ' +
                                    'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              document_chembl_id: 'document_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Assay.getAssaysListURL

    assays = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ASSAY_INDEX_URL
      query_config: queryConfig
      document_chembl_id: chemblID
      aggs_config: aggsConfig

    return assays

  @getRelatedActivitiesAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'document_chembl_id:{{document_chembl_id}}'
      template_data:
        document_chembl_id: 'document_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'document_chembl_id:{{document_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              document_chembl_id: 'document_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      document_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities

  @getAssociatedCompoundsAgg = (chemblID, minCols=1, maxCols=20, defaultCols=10) ->

    # TODO: update after index is updated. https://github.com/chembl/GLaDOS-es/issues/8
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

