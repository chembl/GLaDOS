class TargetReportCardApp extends glados.ReportCardApp

  # -------------------------------------------------------------
  # Initialisation
  # -------------------------------------------------------------
  @init = ->
    super

    target = TargetReportCardApp.getCurrentTarget()

    breadcrumbLinks = [
      {
        label: target.get('id')
        link: Target.get_report_card_url(target.get('id'))
      }
    ]
    glados.apps.BreadcrumbApp.setBreadCrumb(breadcrumbLinks)

    TargetReportCardApp.initTargetNameAndClassification()
    TargetReportCardApp.initTargetComponents()
    TargetReportCardApp.initTargetRelations()
    TargetReportCardApp.initApprovedDrugsClinicalCandidates()
    TargetReportCardApp.initActivityChartsEmbedder()
    TargetReportCardApp.initBioactivities()
    TargetReportCardApp.initAssociatedAssays()
    TargetReportCardApp.initLigandEfficiencies()
    TargetReportCardApp.initAssociatedCompounds()
    TargetReportCardApp.initGeneCrossReferences()
    TargetReportCardApp.initProteinCrossReferences()
    TargetReportCardApp.initDomainCrossReferences()
    TargetReportCardApp.initStructureCrossReferences()


    target.fetch()

  # -------------------------------------------------------------
  # Singleton
  # -------------------------------------------------------------
  @getCurrentTarget = ->

    if not @currentTarget?

      targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()

      @currentTarget = new Target
        target_chembl_id: targetChemblID
        fetch_from_elastic: true
      return @currentTarget

    else return @currentTarget

  # -------------------------------------------------------------
  # Section initialisation
  # -------------------------------------------------------------
  @initTargetNameAndClassification = ->

    target = TargetReportCardApp.getCurrentTarget()

    new TargetNameAndClassificationView
      model: target
      el: $('#TNameClassificationCard')
      section_id: 'TargetNameAndClassification'
      section_label: 'Name And Classification'
      entity_name: Target.prototype.entityName
      report_card_app: @

    if GlobalVariables['EMBEDED']
      target.fetch()

  @initTargetComponents = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    targetComponents = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetComponentsList()
    targetComponents.initURL targetChemblID

    viewConfig =
      embed_section_name: 'components'
      embed_identifier: targetChemblID

    new glados.views.ReportCards.PaginatedTableInCardView
      collection: targetComponents
      el: $('#TComponentsCard')
      resource_type: Target.prototype.entityName
      section_id: 'TargetComponents'
      section_label: 'Components'
      entity_name: Target.prototype.entityName
      config: viewConfig
      report_card_app: @

    targetComponents.fetch({reset: true})

  @initTargetRelations = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    targetRelations = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTargetRelationsList()
    targetRelations.initURL targetChemblID

    viewConfig =
      embed_section_name: 'relations'
      embed_identifier: targetChemblID

    new glados.views.ReportCards.PaginatedTableInCardView
      collection: targetRelations
      el: $('#TRelationsCard')
      resource_type: Target.prototype.entityName
      section_id: 'TargetRelations'
      section_label: 'Relations'
      entity_name: Target.prototype.entityName
      config: viewConfig
      report_card_app: @

    targetRelations.fetch({reset: true})

  #CHEMBL2363965
  @initApprovedDrugsClinicalCandidates = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESMechanismsOfActionList(
      "target.target_chembl_id:#{targetChemblID}",
      listConfig=glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.MECHANISMS_OF_ACTION_TARGET_REPORT_CARD
    )

    viewConfig =
      embed_section_name: 'approved_drugs_clinical_candidates'
      embed_identifier: targetChemblID
      table_config:
        full_list_url: glados.models.Compound.MechanismOfAction.getListURLByTargetChemblId(targetChemblID)

    new glados.views.ReportCards.PaginatedTableInCardView
      collection: list
      el: $('#ApprovedDrugsAndClinicalCandidatesCard')
      resource_type: Target.prototype.entityName
      section_id: 'ApprovedDrugsAndClinicalCandidates'
      section_label: 'Drugs And Clinical Candidates'
      entity_name: Target.prototype.entityName
      config: viewConfig
      report_card_app: @

    list.fetch()

  @initActivityChartsEmbedder = ->

    target = TargetReportCardApp.getCurrentTarget()

    viewConfig =
      resource_type: Target.prototype.entityName
      embed_identifier: target.get('id')

    new glados.views.ReportCards.FullSectionEmbedderView
      model: target
      el: $('#ActivityChartsEmbedder')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Target.prototype.entityName
      report_card_app: @

  @initAllActivityChartsWhenEmbedded = ->

    TargetReportCardApp.initBioactivities()
    TargetReportCardApp.initAssociatedAssays()

  @initBioactivities = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    bioactivities = TargetReportCardApp.getAssociatedBioactivitiesAgg(targetChemblID)
    bioactivitiesProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target', 'ACTIVITY_TYPES')

    pieConfig =
      x_axis_prop_name: 'types'
      title: "Activity Types for Target " + targetChemblID
      title_link_url: Activity.getActivitiesListURL('target_chembl_id:' + targetChemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: bioactivitiesProp


    viewConfig =
      pie_config: pieConfig
      resource_type: Target.prototype.entityName
      embed_section_name: 'bioactivities'
      embed_identifier: targetChemblID
      link_to_all:
        link_text: 'See all bioactivities for target ' + targetChemblID + ' used in this visualisation.'
        url: Activity.getActivitiesListURL('target_chembl_id:' + targetChemblID)

    new glados.views.ReportCards.PieInCardView
      model: bioactivities
      el: $('#TAssociatedBioactivitiesCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Target.prototype.entityName
      report_card_app: @

    bioactivities.fetch()

  @initAssociatedAssays = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedAssays = TargetReportCardApp.getAssociatedAssaysAgg(chemblID)
    associatedAssaysProp = glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target', 'ASSOCIATED_ASSAYS')

    pieConfig =
      x_axis_prop_name: 'types'
      title: "Assays for Target " + chemblID
      title_link_url: Assay.getAssaysListURL('target_chembl_id:' + chemblID)
      max_categories: glados.Settings.PIECHARTS.MAX_CATEGORIES
      properties:
        types: associatedAssaysProp

    viewConfig =
      pie_config: pieConfig
      resource_type: Target.prototype.entityName
      link_to_all:
        link_text: 'See all assays for target ' + chemblID + ' used in this visualisation.'
        url: Assay.getAssaysListURL('target_chembl_id:' + chemblID)
      embed_section_name: 'associated_assays'
      embed_identifier: chemblID

    new glados.views.ReportCards.PieInCardView
      model: associatedAssays
      el: $('#TAssociatedAssaysCard')
      config: viewConfig
      section_id: 'ActivityCharts'
      section_label: 'Activity Charts'
      entity_name: Target.prototype.entityName
      report_card_app: @

    associatedAssays.fetch()

  @initLigandEfficiencies = ->

    targetChemblID = glados.Utils.URLS.getCurrentModelChemblID()
    customQueryString = 'target_chembl_id:' + targetChemblID + ' AND' +
      ' standard_type:(IC50 OR Ki OR EC50 OR Kd) AND _exists_:standard_value AND _exists_:ligand_efficiency'
    ligandEfficiencies = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(customQueryString)

    new glados.views.Target.LigandEfficienciesView
      collection: ligandEfficiencies
      el: $('#TLigandEfficienciesCard')
      target_chembl_id: targetChemblID
      section_id: 'TargetLigandEfficiencies'
      section_label: 'Ligand Efficiencies'
      entity_name: Target.prototype.entityName
      report_card_app: @

  @initAssociatedCompounds = ->

    chemblID = glados.Utils.URLS.getCurrentModelChemblID()
    associatedCompounds = TargetReportCardApp.getAssociatedCompoundsAgg(chemblID)

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
      title: 'Associated Compounds for Target ' + chemblID
      title_link_url: Compound.getCompoundsListURL('_metadata.related_targets.all_chembl_ids:' +
        chemblID)
      external_title: true
      range_categories: true

    config =
      histogram_config: histogramConfig
      resource_type: 'Target'
      embed_section_name: 'associated_compounds'
      embed_identifier: chemblID

    new glados.views.ReportCards.HistogramInCardView
      el: $('#TAssociatedCompoundProperties')
      model: associatedCompounds
      target_chembl_id: chemblID
      config: config
      section_id: 'TargetAssociatedCompoundProperties'
      section_label: 'Associated Compounds'
      entity_name: Target.prototype.entityName
      report_card_app: @

    associatedCompounds.fetch()

  @initGeneCrossReferences = ->

    target = TargetReportCardApp.getCurrentTarget()
    refsConfig =
      is_unichem: false
      filter: (ref) ->
        refsInThisSection = ['ArrayExpress', 'EnsemblGene', 'GoComponent', 'GoFunction', 'GoProcess', 'Wikipedia']
        return ref.xref_src in refsInThisSection

    new glados.views.ReportCards.ReferencesInCardView
      model: target
      el: $('#TGeneCrossReferencesCard')
      embed_section_name: 'gene_cross_refs'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()
      resource_type: Target.prototype.entityName
      section_id: 'TargetCrossReferencesGene'
      section_label: 'Gene Cross References'
      entity_name: Target.prototype.entityName
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      target.fetch()

  @initProteinCrossReferences = ->

    target = TargetReportCardApp.getCurrentTarget()
    refsConfig =
      is_unichem: false
      filter: (ref) ->
        refsInThisSection = ['canSAR-Target', 'CGD', 'ComplexPortal', 'Human Protein Atlas', 'IntAct',
          'GuideToPHARMACOLOGY', 'MICAD', 'PharmGKB', 'Pharos', 'Reactome', 'TIMBAL', 'UniProt', 'Open Targets']
        return ref.xref_src in refsInThisSection

    new glados.views.ReportCards.ReferencesInCardView
      model: target
      el: $('#TProteinCrossReferencesCard')
      embed_section_name: 'protein_cross_refs'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()
      resource_type: Target.prototype.entityName
      section_id: 'TargetCrossReferencesProtein'
      section_label: 'Protein Cross References'
      entity_name: Target.prototype.entityName
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      target.fetch()

  @initDomainCrossReferences = ->

    target = TargetReportCardApp.getCurrentTarget()
    refsConfig =
      is_unichem: false
      filter: (ref) ->
        refsInThisSection = ['InterPro', 'Pfam']
        return ref.xref_src in refsInThisSection

    new glados.views.ReportCards.ReferencesInCardView
      model: target
      el: $('#TDomainCrossReferencesCard')
      embed_section_name: 'domain_cross_refs'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()
      resource_type: Target.prototype.entityName
      section_id: 'TargetCrossReferencesDomain'
      section_label: 'Domain Cross References'
      entity_name: Target.prototype.entityName
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      target.fetch()

  @initStructureCrossReferences = ->

    target = TargetReportCardApp.getCurrentTarget()
    refsConfig =
      is_unichem: false
      filter: (ref) ->
        refsInThisSection = ['PDBe', 'CREDO']
        return ref.xref_src in refsInThisSection

    new glados.views.ReportCards.ReferencesInCardView
      model: target
      el: $('#TStructureCrossReferencesCard')
      embed_section_name: 'structure_cross_refs'
      embed_identifier: glados.Utils.URLS.getCurrentModelChemblID()
      resource_type: Target.prototype.entityName
      section_id: 'TargetCrossReferencesStructure'
      section_label: 'Structure Cross References'
      entity_name: Target.prototype.entityName
      report_card_app: @
      config:
        refs_config: refsConfig

    if GlobalVariables['EMBEDED']
      target.fetch()

  @initMiniBioactivitiesHistogram = ($containerElem, chemblID) ->

    bioactivities = TargetReportCardApp.getAssociatedBioactivitiesAgg(chemblID)

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

    associatedCompounds = TargetReportCardApp.getAssociatedCompoundsAgg(chemblID, minCols=8,
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
    targetChemblID = paramsList[0]
    if histogramType == 'activities'
      TargetReportCardApp.initMiniBioactivitiesHistogram($containerElem, targetChemblID)
    else if histogramType == 'compounds'
      TargetReportCardApp.initMiniCompoundsHistogram($containerElem, targetChemblID)

  # --------------------------------------------------------------------------------------------------------------------
  # Aggregations
  # --------------------------------------------------------------------------------------------------------------------
  @getAssociatedCompoundsAgg = (chemblID, minCols=1, maxCols=20, defaultCols=10) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.MULTIMATCH
      queryValueField: 'target_chembl_id'
      fields: ['_metadata.related_targets.all_chembl_ids']

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'molecule_properties.full_mwt'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          min_columns: minCols
          max_columns: maxCols
          num_columns: defaultCols
          bucket_links:
            bucket_filter_template: '_metadata.related_targets.all_chembl_ids:{{target_chembl_id}} ' +
              'AND molecule_properties.full_mwt:(>={{min_val}} AND <={{max_val}})'
            template_data:
              target_chembl_id: 'target_chembl_id'
              min_val: 'BUCKET.from'
              max_val: 'BUCKETS.to'
            link_generator: Compound.getCompoundsListURL

    associatedCompounds = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.COMPOUND_INDEX_URL
      query_config: queryConfig
      target_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedCompounds

  @getAssociatedBioactivitiesAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'target_chembl_id:{{target_chembl_id}}'
      template_data:
        target_chembl_id: 'target_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: 'standard_type'
          size: 20
          bucket_links:

            bucket_filter_template: 'target_chembl_id:{{target_chembl_id}} ' +
                                    'AND standard_type:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              target_chembl_id: 'target_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Activity.getActivitiesListURL

    bioactivities = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ACTIVITY_INDEX_URL
      query_config: queryConfig
      target_chembl_id: chemblID
      aggs_config: aggsConfig

    return bioactivities

  @getAssociatedAssaysAgg = (chemblID) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: 'target_chembl_id:{{target_chembl_id}}'
      template_data:
        target_chembl_id: 'target_chembl_id'

    aggsConfig =
      aggs:
        types:
          type: glados.models.Aggregations.Aggregation.AggTypes.TERMS
          field: '_metadata.assay_generated.type_label'
          size: 20
          bucket_links:

            bucket_filter_template: 'target_chembl_id:{{target_chembl_id}} ' +
                                    'AND _metadata.assay_generated.type_label:("{{bucket_key}}"' +
                                    '{{#each extra_buckets}} OR "{{this}}"{{/each}})'
            template_data:
              target_chembl_id: 'target_chembl_id'
              bucket_key: 'BUCKET.key'
              extra_buckets: 'EXTRA_BUCKETS.key'

            link_generator: Assay.getAssaysListURL

    associatedAssays = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.ASSAY_INDEX_URL
      query_config: queryConfig
      target_chembl_id: chemblID
      aggs_config: aggsConfig

    return associatedAssays