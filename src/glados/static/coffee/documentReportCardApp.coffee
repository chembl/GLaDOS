class DocumentReportCardApp extends glados.ReportCardApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    super
    document = DocumentReportCardApp.getCurrentDocument()

    breadcrumbLinks = [
      {
        label: document.get('id')
        link: Document.get_report_card_url(document.get('id'))
      }
    ]
    glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks)

    DocumentReportCardApp.initBasicInformation()
    DocumentReportCardApp.initRelatedDocuments()
    DocumentReportCardApp.initWordCloud()
    DocumentReportCardApp.initActivitySummary()
    DocumentReportCardApp.initTargetSummary()
    DocumentReportCardApp.initAssaySummary()
    DocumentReportCardApp.initCompoundSummary()

    document.fetch()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentDocument = ->

    if not @currentDocument?

      chemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentDocument = new Document
        document_chembl_id: chemblID
        fetch_from_elastic: true
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
      entity_name: Document.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      document.fetch()

  @initRelatedDocuments = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()

    document = DocumentReportCardApp.getCurrentDocument()
    relatedDocumentsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewRelatedDocumentsList()

    viewConfig =
      embed_section_name: 'related_documents'
      embed_identifier: chemblID
      link_to_all_text: "Browse all documents related to #{chemblID}"
      link_to_all_url: Document.getDocumentsListURL("_metadata.similar_documents.document_chembl_id:(\"#{chemblID}\")")

    new glados.views.ReportCards.PaginatedTableInCardView
      collection: relatedDocumentsList
      el: $('#CRelatedDocumentsCard')
      resource_type: gettext('glados_entities_document_name')
      section_id: 'RelatedDocuments'
      section_label: 'Related Documents'
      entity_name: Document.prototype.entityName
      config: viewConfig
      report_card_app: @

    initRelatedDocsList = ->

      rawSimilarDocs = document.get('_metadata').similar_documents
      rawSimilarDocs ?= []

      relatedDocumentsList.setMeta('data_loaded', true)
      relatedDocumentsList.reset(_.map(rawSimilarDocs, Document.prototype.parse))

    document.on 'change', initRelatedDocsList

    if GlobalVariables['EMBEDED']
      document.fetch()

  @initWordCloud = ->

    docTerms = new DocumentTerms
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentWordCloudView
      model: docTerms
      el: $('#DWordCloudCard')
      section_id: 'WordCloud'
      section_label: 'Word Cloud'
      entity_name: Document.prototype.entityName
      report_card_app: @

    docTerms.fetch()

  @initTargetSummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedTargets = DocumentReportCardApp.getRelatedTargetsAggByClass(chemblID)
    relatedTargetsProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Document', 'RELATED_TARGETS')

    pieConfig =
      x_axis_prop_name: 'classes'
      title: gettext('glados_compound__associated_targets_by_class_pie_title_base') + chemblID
      title_link_url: Target.getTargetsListURL('_metadata.related_documents.chembl_ids.\\*:' + chemblID)
      custom_empty_message: "No target classification data available for document #{chemblID} (all may be non-protein targets)"
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        classes: relatedTargetsProp

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
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Document.prototype.entityName
      report_card_app: @

    relatedTargets.fetch()

  @initAssaySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedAssays = DocumentReportCardApp.getRelatedAssaysAgg(chemblID)
    relatedAssaysProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Document', 'RELATED_ASSAYS')

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_document__associated_assays_pie_title_base') + chemblID
      title_link_url: Assay.getAssaysListURL('document_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: relatedAssaysProp


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
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Document.prototype.entityName
      report_card_app: @

    relatedAssays.fetch()

  @initActivitySummary = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    relatedActivities = DocumentReportCardApp.getRelatedActivitiesAgg(chemblID)
    relatedActivitiesProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Document', 'RELATED_ACTIVITIES')

    pieConfig =
      x_axis_prop_name: 'types'
      title: gettext('glados_document__associated_activities_pie_title_base') + chemblID
      title_link_url: Activity.getActivitiesListURL('document_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: relatedActivitiesProp

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
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Document.prototype.entityName
      report_card_app: @

    relatedActivities.fetch()

  @initCompoundSummary = ->

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
      title_link_url: Compound.getCompoundsListURL('_metadata.related_documents.chembl_ids.\\*:' + chemblID)
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
      entity_name: Document.prototype.entityName
      report_card_app: @


    associatedCompounds.fetch()



  # -------------------------------------------------------------
  # Full Screen views
  # -------------------------------------------------------------
  @initAssayNetworkFS = ->

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: GlobalVariables.CHEMBL_ID

    danFSView = new DocumentAssayNetworkFSView
      model: documentAssayNetwork
      el: $('#DAN-Main')

    documentAssayNetwork.fetch()

  # -------------------------------------------------------------
  # Aggregations
  # -------------------------------------------------------------
  @getRelatedTargetsAggByClass = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'document_chembl_id'
      fields: ['_metadata.related_documents.chembl_ids.*']

    aggsConfig =
      aggs:
        classes:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.protein_classification.l1'
          size: 20
          bucket_links:

            bucket_filter_template: '_metadata.related_documents.chembl_ids.\\*:{{document_chembl_id}} ' +
                                    'AND _metadata.protein_classification.l1:("{{bucket_key}}"' +
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

  @getRelatedTargetsAgg = (chemblID) ->

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

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'document_chembl_id'
      fields: ['_metadata.related_documents.chembl_ids.*']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: minCols
          max_columns: maxCols
          num_columns: defaultCols
          bucket_links:
            bucket_filter_template: '_metadata.related_documents.chembl_ids.\\*:{{document_chembl_id}} ' +
              'AND molecule_properties.full_mwt:(>={{min_val}} AND <={{max_val}})'
            template_data:
              document_chembl_id: 'document_chembl_id'
              min_val: 'BUCKET.from'
              max_val: 'BUCKETS.to'
            link_generator: Compound.getCompoundsListURL

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      document_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedCompounds

  # --------------------------------------------------------------------------------------------------------------------
  # mini Histograms
  # --------------------------------------------------------------------------------------------------------------------
  @initMiniActivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = DocumentReportCardApp.getRelatedActivitiesAgg(chemblID)

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

    associatedCompounds = DocumentReportCardApp.getAssociatedCompoundsAgg(chemblID, minCols=8,
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

  @initMiniTargetsHistogram = ($containerElem, chemblID) ->

    targetTypes = DocumentReportCardApp.getRelatedTargetsAgg(chemblID)

    stdTypeProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target', 'TARGET_TYPE',
    withColourScale=true)

    barsColourScale = stdTypeProp.colourScaleRnage

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
      model: targetTypes
      el: $containerElem
      config: config

    targetTypes.fetch()

  @initMiniHistogramFromFunctionLink = ->

    $clickedLink = $(@)

    [paramsList, constantParamsList, $containerElem] = \
    glados.views.PaginatedViews.PaginatedTable.prepareAndGetParamsFromFunctionLinkCell($clickedLink)

    histogramType = constantParamsList[0]
    chemblID = paramsList[0]

    if histogramType == 'activities'
      DocumentReportCardApp.initMiniActivitiesHistogram($containerElem, chemblID)
    else if histogramType == 'compounds'
      DocumentReportCardApp.initMiniCompoundsHistogram($containerElem, chemblID)
    else if histogramType == 'targets'
      DocumentReportCardApp.initMiniTargetsHistogram($containerElem, chemblID)



