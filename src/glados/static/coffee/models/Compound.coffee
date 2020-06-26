Compound = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  entityName: 'Compound'
  entityNamePlural: 'Compounds'
  idAttribute: 'molecule_chembl_id'
  defaults:
    fetch_from_elastic: true
  indexName: 'chembl_molecule'
  initialize: ->

    id = @get('id')
    id ?= @get('molecule_chembl_id')
    @set('id', id)
    @set('molecule_chembl_id', id)

    if @get('fetch_from_elastic')
      @url = "#{glados.Settings.ES_PROXY_API_BASE_URL}/es_data/get_es_document/#{Compound.ES_INDEX}/#{id}"
    else
      @url = glados.Settings.WS_BASE_URL + 'molecule/' + id + '.json'

    if @get('enable_similarity_map')
      @set('loading_similarity_map', true)
      @loadSimilarityMap()

      @on 'change:molecule_chembl_id', @loadSimilarityMap, @
      @on 'change:reference_smiles', @loadSimilarityMap, @
      @on 'change:reference_smiles_error', @loadSimilarityMap, @

    if @get('enable_substructure_highlighting')
      @set('loading_substructure_highlight', true)
      @loadStructureHighlight()

      @on 'change:molecule_chembl_id', @loadStructureHighlight, @
      @on 'change:reference_ctab', @loadStructureHighlight, @
      @on 'change:reference_smarts', @loadStructureHighlight, @
      @on 'change:reference_smiles_error', @loadStructureHighlight, @

  isParent: ->

    metadata = @get('_metadata')
    if not metadata.hierarchy.parent?
      return true
    else return false

  # --------------------------------------------------------------------------------------------------------------------
  # Sources
  # --------------------------------------------------------------------------------------------------------------------
  hasAdditionalSources: ->

    additionalSourcesState = @get('has_additional_sources')
    if not additionalSourcesState?
      @getAdditionalSources()
    additionalSourcesState = @get('has_additional_sources')
    return additionalSourcesState

  getAdditionalSources: ->

    aditionalSourcesCache = @get('additional_sources')
    if aditionalSourcesCache?
      return aditionalSourcesCache

    metadata = @get('_metadata')
    ownSources = _.unique(v.src_description for v in metadata.compound_records)

    if @isParent()

      childrenSourcesList = (c.sources for c in metadata.hierarchy.children)
      uniqueSourcesObj = {}
      sourcesFromChildren = []
      for sourcesObj in childrenSourcesList
        for source in _.values(sourcesObj)
          srcDescription = source.src_description
          if not uniqueSourcesObj[srcDescription]?
            uniqueSourcesObj[srcDescription] = true
            sourcesFromChildren.push(srcDescription)

      additionalSources = _.difference(sourcesFromChildren, ownSources)
    else
      sourcesFromParent = (v.src_description for v in _.values(metadata.hierarchy.parent.sources))
      additionalSources = _.difference(sourcesFromParent, ownSources)

    if additionalSources.length == 0
      @set({has_additional_sources: false}, {silent:true})
    else
      @set({has_additional_sources: true}, {silent:true})

    additionalSources.sort()

    @set({additional_sources: additionalSources}, {silent:true})
    return additionalSources

  # --------------------------------------------------------------------------------------------------------------------
  # Synonyms and trade names
  # --------------------------------------------------------------------------------------------------------------------
  separateSynonymsAndTradeNames: (rawSynonymsAndTradeNames) ->

    uniqueSynonymsObj = {}
    uniqueSynonymsList = []

    uniqueTradeNamesObj = {}
    uniqueTradeNamesList = []

    for rawItem in rawSynonymsAndTradeNames

      itemName = rawItem.synonyms
      # is this a proper synonym?
      if rawItem.syn_type != 'TRADE_NAME'

        if not uniqueSynonymsObj[itemName]?
          uniqueSynonymsObj[itemName] = true
          uniqueSynonymsList.push(itemName)
      #or is is a tradename?
      else

        if not uniqueTradeNamesObj[itemName]?
          uniqueTradeNamesObj[itemName] = true
          uniqueTradeNamesList.push(itemName)

    return [uniqueSynonymsList, uniqueTradeNamesList]

  calculateSynonymsAndTradeNames: ->

    rawSynonymsAndTradeNames = @get('molecule_synonyms')
    [uniqueSynonymsList, uniqueTradeNamesList] = @separateSynonymsAndTradeNames(rawSynonymsAndTradeNames)

    metadata = @get('_metadata')
    if @isParent()

      rawChildrenSynonymsAndTradeNamesLists = (c.synonyms for c in metadata.hierarchy.children)
      rawChildrenSynonyms = []
      for rawSynAndTNList in rawChildrenSynonymsAndTradeNamesLists
        for syn in rawSynAndTNList
          rawChildrenSynonyms.push(syn)

      [synsFromChildren, tnsFromChildren] = @separateSynonymsAndTradeNames(rawChildrenSynonyms)
      additionalSynsList = _.difference(synsFromChildren, uniqueSynonymsList)
      additionalTnsList = _.difference(tnsFromChildren, uniqueTradeNamesList)

    else

      console.log 'metadata: ', metadata
      rawSynonymsAndTradeNamesFromParent = _.values(metadata.hierarchy.parent.synonyms)
      [synsFromParent, tnsFromParent] = @separateSynonymsAndTradeNames(rawSynonymsAndTradeNamesFromParent)

      additionalSynsList = _.difference(synsFromParent, uniqueSynonymsList)
      additionalTnsList = _.difference(tnsFromParent, uniqueTradeNamesList)

    @set
      only_synonyms: uniqueSynonymsList
      additional_only_synonyms: additionalSynsList
      only_trade_names: uniqueTradeNamesList
      additional_trade_names: additionalTnsList
    ,
      silent: true

  getSynonyms: -> @getWithCache('only_synonyms', @calculateSynonymsAndTradeNames.bind(@))
  getTradenames: -> @getWithCache('only_trade_names', @calculateSynonymsAndTradeNames.bind(@))
  getAdditionalSynonyms: -> @getWithCache('additional_only_synonyms', @calculateSynonymsAndTradeNames.bind(@))
  getAdditionalTradenames: -> @getWithCache('additional_trade_names', @calculateSynonymsAndTradeNames.bind(@))
  getOwnAndAdditionalSynonyms: ->
    synonyms = @getSynonyms()
    additionalSynonyms = @getAdditionalSynonyms()
    return _.union(synonyms, additionalSynonyms)
  getOwnAndAdditionalTradenames: ->
    tradenames = @getTradenames()
    additionalTradenames = @getAdditionalTradenames()
    return _.union(tradenames, additionalTradenames)
  # --------------------------------------------------------------------------------------------------------------------
  # instance cache
  # --------------------------------------------------------------------------------------------------------------------
  getWithCache: (propName, generator) ->

    cache = @get(propName)
    if not cache?
      generator()
    cache = @get(propName)
    return cache

  # --------------------------------------------------------------------------------------------------------------------
  # Family ids
  # --------------------------------------------------------------------------------------------------------------------
  calculateChildrenIDs: ->

    metadata = @get('_metadata')
    childrenIDs = (c.chembl_id for c in metadata.hierarchy.children)
    @set
      children_ids: childrenIDs
    ,
      silent: true

  getChildrenIDs: -> @getWithCache('children_ids', @calculateChildrenIDs.bind(@))
  getParentID: ->
    metadata = @get('_metadata')
    if @isParent()
      return @get('id')
    else
      return metadata.hierarchy.parent.chembl_id

  calculateAdditionalIDs: ->
    metadata = @get('_metadata')
    additionalIDs = []

    if metadata.hierarchy?
      if @.isParent()
        childrenIDs = @getChildrenIDs()
        for childID in childrenIDs
          additionalIDs.push childID
      else
        parentID = @getParentID()
        additionalIDs.push parentID

    @set
      additional_ids: additionalIDs
    ,
      silent: true

  getOwnAndAdditionalIDs: ->
    ownID = @get('id')
    ids = [ownID]
    additionalIDs = @getWithCache('additional_ids', @calculateAdditionalIDs.bind(@))
    for id in additionalIDs
      ids.push id
    return ids

  loadSimilarityMap:  ->

    if @get('reference_smiles_error')
      @set('loading_similarity_map', false)
      @trigger glados.Events.Compound.SIMILARITY_MAP_ERROR
      return

    # to start I need the smiles of the compound and the compared one
    structures = @get('molecule_structures')
    if not structures?
      return

    referenceSmiles = @get('reference_smiles')
    if not referenceSmiles?
      return

    @downloadSimilaritySVG()

  loadStructureHighlight: ->

    if @get('reference_smiles_error')
      @set('loading_substructure_highlight', false)
      @trigger glados.Events.Compound.STRUCTURE_HIGHLIGHT_ERROR
      return

    referenceSmiles = @get('reference_smiles')
    if not referenceSmiles?
      return

    referenceCTAB = @get('reference_ctab')
    if not referenceCTAB?
      return

    referenceSmarts = @get('reference_smarts')
    if not referenceSmarts?
      return

    model = @
    downloadHighlighted = ->
      model.downloadHighlightedSVG()

    @download2DSDF().then downloadHighlighted, downloadHighlighted

  #---------------------------------------------------------------------------------------------------------------------
  # Parsing
  #---------------------------------------------------------------------------------------------------------------------
  parse: (response) ->

    # get data when it comes from elastic
    if response._source?
      objData = response._source
    else
      objData = response

    filterForActivities = 'molecule_chembl_id:' + objData.molecule_chembl_id
    objData.activities_url = Activity.getActivitiesListURL(filterForActivities)

    # Lazy definition for sdf content retrieving
    objData.sdf_url = glados.Settings.WS_BASE_URL + 'molecule/' + objData.molecule_chembl_id + '.sdf'
    objData.sdf_promise = null
    objData.get_sdf_content_promise = ->
      if not objData.sdf_promise
        objData.sdf_promise = $.ajax(objData.sdf_url)
      return objData.sdf_promise

    # Calculate the rule of five from other properties
    if objData.molecule_properties?
      objData.ro5 = objData.molecule_properties.num_ro5_violations == 0
    else
      objData.ro5 = false

    # Computed Image and report card URL's for Compounds
    objData.structure_image = false
    if objData.structure_type == 'NONE' or objData.structure_type == 'SEQ'
      # see the cases here: https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?spaceKey=CHEMBL&title=ChEMBL+Interface
      # in the section Placeholder Compound Images

      if objData.molecule_properties?
        if glados.Utils.Compounds.containsMetals(objData.molecule_properties.full_molformula)
          objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/metalContaining.svg'
      else if objData.molecule_type == 'Oligosaccharide'
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligosaccharide.svg'
      else if objData.molecule_type == 'Small molecule'

        if objData.natural_product == '1'
          objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/naturalProduct.svg'
        else if objData.polymer_flag == true
          objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolPolymer.svg'
        else
          objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolecule.svg'

      else if objData.molecule_type == 'Antibody'
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/antibody.svg'
      else if objData.molecule_type == 'Protein'
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/peptide.svg'
      else if objData.molecule_type == 'Oligonucleotide'
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligonucleotide.svg'
      else if objData.molecule_type == 'Enzyme'
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/enzyme.svg'
      else if objData.molecule_type == 'Cell'
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/cell.svg'
      else #if response.molecule_type == 'Unclassified' or response.molecule_type = 'Unknown' or not response.molecule_type?
        objData.image_url = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/unknown.svg'


      #response.image_url = glados.Settings.OLD_DEFAULT_IMAGES_BASE_URL + response.molecule_chembl_id
    else
      objData.image_url = glados.Settings.WS_BASE_URL + 'image/' + objData.molecule_chembl_id + '.svg'
      objData.structure_image = true

    objData.report_card_url = Compound.get_report_card_url(objData.molecule_chembl_id)

    filterForTargets = '_metadata.related_compounds.all_chembl_ids:' + objData.molecule_chembl_id
    objData.targets_url = Target.getTargetsListURL(filterForTargets)

    @parseChemSpiderXref(objData)
    @parseATCXrefs(objData)
    return objData;

  #---------------------------------------------------------------------------------------------------------------------
  # Get extra xrefs
  #---------------------------------------------------------------------------------------------------------------------
  parseChemSpiderXref: (objData) ->

    molStructures = objData.molecule_structures
    if not molStructures?
      return

    inchiKey = molStructures.standard_inchi_key
    if not inchiKey?
      return

    chemSpiderLink = "https://www.chemspider.com/Search.aspx?q=#{inchiKey}"
    chemSpiderSourceLink = "https://www.chemspider.com/"
    chemSpidetLinkText = "ChemSpider:#{inchiKey}"

    if not objData.cross_references?
      objData.cross_references = []

    objData.cross_references.push
      xref_name: chemSpidetLinkText,
      xref_src: 'ChemSpider',
      xref_id: inchiKey,
      xref_url: chemSpiderLink,
      xref_src_url: chemSpiderSourceLink

  parseATCXrefs: (objData) ->

    metadata = objData._metadata
    if not metadata?
      return

    atcClassifications = metadata.atc_classifications
    if not atcClassifications?
      return

    if atcClassifications.length == 0
      return

    for classification in atcClassifications

      levelsList = []
      for i in [1..5]

        levelNameKey = "level#{i}"
        levelNameData = classification[levelNameKey]

        levelLink = "http://www.whocc.no/atc_ddd_index/?code=#{levelNameData}&showdescription=yes"

        if i != 5
          levelDescKey = "level#{i}_description"
          levelDescData = classification[levelDescKey].split(' - ')[1]
        else
          levelDescData = classification.who_name

        levelsList.push
          name: levelNameData
          description: levelDescData
          link: levelLink

      refsOBJ =
        xref_src: 'ATC'
        xref_src_url: 'https://www.whocc.no/atc_ddd_index/'
        xref_name: 'One ATC Group'
        levels_refs: levelsList

      if not objData.cross_references?
        objData.cross_references = []
    
      objData.cross_references.push refsOBJ

  #---------------------------------------------------------------------------------------------------------------------
  # Similarity
  #---------------------------------------------------------------------------------------------------------------------

  downloadSimilaritySVG: ()->
    @set
      reference_smiles_error: false
      download_similarity_map_error: false
    ,
      silent: true
    model = @
    promiseFunc = (resolve, reject)->
      referenceSmiles = model.get('reference_smiles')
      structures = model.get('molecule_structures')
      if not referenceSmiles?
        reject('Error, there is no reference SMILES PRESENT!')
        return
      if not structures?
        reject('Error, the compound does not have structures data!')
        return
      mySmiles = structures.canonical_smiles
      if not mySmiles?
        reject('Error, the compound does not have SMILES data!')
        return

      if model.get('similarity_map_base64_img')?
        resolve(model.get('similarity_map_base64_img'))
      else
        formData = new FormData()
        formData.append('file', new Blob([referenceSmiles+'\n'+mySmiles], {type: 'chemical/x-daylight-smiles'}), 'sim.smi')
        formData.append('format', 'svg')
        formData.append('height', '500')
        formData.append('width', '500')
        formData.append('sanitize', 0)
        ajax_deferred = $.post
          url: Compound.SMILES_2_SIMILARITY_MAP_URL
          data: formData
          enctype: 'multipart/form-data'
          processData: false
          contentType: false
          cache: false
          converters:
            'text xml': String
        ajax_deferred.done (ajaxData)->
          model.set
            loading_similarity_map: false
            similarity_map_base64_img: 'data:image/svg+xml;base64,'+btoa(ajaxData)
            reference_smiles_error: false
            reference_smiles_error_jqxhr: undefined
          ,
            silent: true

          model.trigger glados.Events.Compound.SIMILARITY_MAP_READY
          resolve(ajaxData)
        ajax_deferred.fail (jqxhrError)->
          reject(jqxhrError)
    promise = new Promise(promiseFunc)
    promise.then null, (jqxhrError)->
      model.set
        download_similarity_map_error: true
        loading_similarity_map: false
        reference_smiles_error: true
        reference_smiles_error_jqxhr: jqxhrError
      ,
        silent: true

      model.trigger glados.Events.Compound.SIMILARITY_MAP_ERROR
    return promise

  #---------------------------------------------------------------------------------------------------------------------
  # Highlighting
  #---------------------------------------------------------------------------------------------------------------------

  downloadHighlightedSVG: ()->
    @set
      'reference_smiles_error': false
      'download_highlighted_error': false
    ,
      silent: true
    model = @
    promiseFunc = (resolve, reject)->
      referenceSmarts = model.get('reference_smarts')
      # Tries to use the 2d sdf without alignment if the alignment failed
      if model.get('aligned_sdf')?
        alignedSdf = model.get('aligned_sdf')
      else
        alignedSdf = model.get('sdf2DData')
      if not referenceSmarts?
        reject('Error, the reference SMARTS is not present!')
        return
      if not alignedSdf?
        reject('Error, the compound '+model.get('molecule_chembl_id')+' ALIGNED CTAB is not present!')
        return

      if model.get('substructure_highlight_base64_img')?
        resolve(model.get('substructure_highlight_base64_img'))
      else
        formData = new FormData()
        formData.append('file', new Blob([alignedSdf], {type: 'chemical/x-mdl-molfile'}), 'aligned.mol')
        formData.append('smarts', referenceSmarts)
        formData.append('computeCoords', 0)
        formData.append('force', 'true')
        formData.append('sanitize', 0)
        ajax_deferred = $.post
          url: Compound.SDF_2D_HIGHLIGHT_URL
          data: formData
          enctype: 'multipart/form-data'
          processData: false
          contentType: false
          cache: false
          converters:
            'text xml': String
        ajax_deferred.done (ajaxData)->
          model.set
            loading_substructure_highlight: false
            substructure_highlight_base64_img: 'data:image/svg+xml;base64,'+btoa(ajaxData)
            reference_smiles_error: false
            reference_smiles_error_jqxhr: undefined
          ,
            silent: true
          model.trigger glados.Events.Compound.STRUCTURE_HIGHLIGHT_READY
          resolve(ajaxData)
        ajax_deferred.fail (jqxhrError)->
          reject(jqxhrError)
    promise = new Promise(promiseFunc)
    promise.then null, (jqxhrError)->
      model.set
        loading_substructure_highlight: false
        download_highlighted_error: true
        reference_smiles_error: true
        reference_smiles_error_jqxhr: jqxhrError
      model.trigger glados.Events.Compound.STRUCTURE_HIGHLIGHT_ERROR
    return promise

  #---------------------------------------------------------------------------------------------------------------------
  # SDF
  #---------------------------------------------------------------------------------------------------------------------

  download2DSDF: ()->
    @set('sdf2DError', false, {silent: true})
    promiseFunc = (resolve, reject)->
      if @get('sdf2DData')?
        resolve(@get('sdf2DData'))
      else
        ajax_deferred = $.get(Compound.SDF_2D_URL + @get('molecule_chembl_id') + '.sdf')
        compoundModel = @
        ajax_deferred.done (ajaxData)->
          compoundModel.set('sdf2DData', ajaxData)
          resolve(ajaxData)
        ajax_deferred.fail (error)->
          compoundModel.set('sdf2DError', true)
          reject(error)
    return new Promise(promiseFunc.bind(@))

  #---------------------------------------------------------------------------------------------------------------------
  # instance urls
  #---------------------------------------------------------------------------------------------------------------------
  getSimilaritySearchURL: (threshold=glados.Settings.DEFAULT_SIMILARITY_THRESHOLD) ->

    glados.Settings.SIMILARITY_URL_GENERATOR
      term: @get('id')
      threshold: threshold

#-----------------------------------------------------------------------------------------------------------------------
# 3D SDF Constants
#-----------------------------------------------------------------------------------------------------------------------

Compound.SDF_2D_HIGHLIGHT_URL = glados.Settings.BEAKER_BASE_URL + 'highlightCtabFragmentSvg'
Compound.SDF_2D_URL = glados.Settings.WS_BASE_URL + 'molecule/'
Compound.SMILES_2_SIMILARITY_MAP_URL = glados.Settings.BEAKER_BASE_URL + 'smiles2SimilarityMapSvg'

# Constant definition for ReportCardEntity model functionalities
_.extend(Compound, glados.models.base.ReportCardEntity)
Compound.color = 'cyan'
Compound.reportCardPath = 'compound_report_card/'

Compound.getSDFURL = (chemblId) -> glados.Settings.WS_BASE_URL + 'molecule/' + chemblId + '.sdf'

Compound.ES_INDEX = 'chembl_molecule'

Compound.INDEX_NAME = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'molecule'

Compound.PROPERTIES_VISUAL_CONFIG = {
  'molecule_chembl_id': {
    link_base: 'report_card_url'
    image_base_url: 'image_url'
    hide_label: true
  },
  'molecule_synonyms': {
    parse_function: (values) -> _.uniq(v.molecule_synonym for v in values).join(', ')
  },
  '_metadata.related_targets.count': {
    format_as_number: true
    link_base: 'targets_url'
    on_click: CompoundReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['molecule_chembl_id']
    function_constant_parameters: ['targets']
    function_key: 'targets'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  },
  '_metadata.related_activities.count': {
    link_base: 'activities_url'
    on_click: CompoundReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['molecule_chembl_id']
    function_constant_parameters: ['activities']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    function_key: 'bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  },
  'similarity': {
    'show': true
    'comparator': '_context.similarity'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
  'sources_list': {
    parse_function: (values) -> _.unique(v.src_description for v in values)
  }
  'additional_sources_list': {
    name_to_show_function: (model) ->

      switch model.isParent()
        when true then return 'Additional Sources From Alternate Forms:'
        when false then return 'Additional Sources From Parent:'

    col_value_function: (model) -> model.getAdditionalSources()
    show_function: (model) -> model.hasAdditionalSources()
  }
  'chochrane_terms': {
    comparator: 'pref_name'
    additional_parsing:
      encoded_value: (value) -> value.replace(/[ ]/g, '+')
  }
  'clinical_trials_terms': {
    parse_function: (values) -> _.uniq(v.molecule_synonym for v in values).join(', ')
    parse_from_model: true
    additional_parsing:
      search_term: (model) ->
        synonyms = if model.isParent() then model.getOwnAndAdditionalSynonyms() else model.getSynonyms()
        tradenames = if model.isParent() then model.getOwnAndAdditionalTradenames() else model.getTradenames()
        fullList = _.union(synonyms, tradenames)
        linkText = _.uniq(v for v in fullList).join(' OR ')

        maxTextLength = 100
        if linkText.length > maxTextLength
          linkText = "#{linkText.substring(0, (maxTextLength-3))}..."

        return linkText
      encoded_search_term: (model) ->
        synonyms = if model.isParent() then model.getOwnAndAdditionalSynonyms() else model.getSynonyms()
        tradenames = if model.isParent() then model.getOwnAndAdditionalTradenames() else model.getTradenames()
        fullList = _.union(synonyms, tradenames)
        return encodeURIComponent(_.uniq(v for v in fullList).join(' OR '))
  }
}

Compound.COLUMNS = {

  CHEMBL_ID:

    aggregatable: true
    comparator: "molecule_chembl_id"
    hide_label: true
    id: "molecule_chembl_id"
    image_base_url: "image_url"
    is_sorting: 0
    link_base: "report_card_url"
    name_to_show: "ChEMBL ID"
    name_to_show_short: "ChEMBL ID"
    show: true
    sort_class: "fa-sort"
    sort_disabled: false


  SYNONYMS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'molecule_synonyms'
    parse_function: (values) -> _.uniq(v.molecule_synonym for v in values).join(', ')
  PREF_NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'pref_name'
  MOLECULE_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'molecule_type'
  MAX_PHASE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'max_phase'
  DOSED_INGREDIENT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'Dosed Ingredient'
    comparator: 'dosed_ingredient'
  SIMILARITY_ELASTIC: {
      'show': true
      'name_to_show': 'Similarity'
      'comparator': '_context.similarity'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'is_contextual': true
    }
  STRUCTURE_TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'structure_type'
  INORGANIC_FLAG: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'inorganic_flag'
  FULL_MWT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'molecule_properties.full_mwt'
  ALOGP: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    comparator: 'molecule_properties.alogp'

}

Compound.ID_COLUMN = Compound.COLUMNS.CHEMBL_ID

Compound.COLUMNS_SETTINGS = {

  RESULTS_LIST_REPORT_CARD_LONG:[
    Compound.COLUMNS.CHEMBL_ID,
    Compound.COLUMNS.PREF_NAME,
    Compound.COLUMNS.MAX_PHASE,
    Compound.COLUMNS.FULL_MWT,
    Compound.COLUMNS.ALOGP
  ]

}


Compound.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'

Compound.getCompoundsListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'compounds'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState