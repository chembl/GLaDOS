class DocumentReportCardApp

  # -------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------
  @init = ->

    document = DocumentReportCardApp.getCurrentDocument()

    DocumentReportCardApp.initBasicInformation()
    DocumentReportCardApp.initAssayNetwork()
    DocumentReportCardApp.initWordCloud()
    DocumentReportCardApp.initTargetSummary()

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

    if GlobalVariables['EMBEDED']
      document.fetch()

  @initAssayNetwork = ->

    documentAssayNetwork = new DocumentAssayNetwork
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentAssayNetworkView
      model: documentAssayNetwork
      el: $('#DAssayNetworkCard')

    documentAssayNetwork.fetch()

  @initWordCloud = ->

    docTerms = new DocumentTerms
      document_chembl_id: glados.Utils.URLS.getCurrentModelChemblID()

    new DocumentWordCloudView
      model: docTerms
      el: $('#DWordCloudCard')

    docTerms.fetch()

  @initTargetSummary = ->

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
        url: Target.getTargetsListURL()

    new glados.views.ReportCards.PieInCardView
      model: relatedTargets
      el: $('#DAssociatedTargetsCard')
      config: viewConfig

    relatedTargets.fetch()

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

    #TODO: update when index is updated
    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'target_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'target_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Target.getTargetsListURL

    targetTypes = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.TARGET_INDEX_URL
      query_config: queryConfig
      molecule_chembl_id: chemblID
      aggs_config: aggsConfig

    return targetTypes


