Target = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  entityName: 'Target'
  entityNamePlural: 'Targets'
  idAttribute: 'target_chembl_id'
  defaults:
    fetch_from_elastic: true
  initialize: ->
    @on 'change', @getProteinTargetClassification, @
    @initURL()

  initURL: ->

    id = @get('id')
    id ?= @get('target_chembl_id')
    @set('id', id)
    @set('target_chembl_id', id)

    if @get('fetch_from_elastic')
      @url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_target/_doc/' + id
    else
      @url = glados.Settings.WS_BASE_URL + 'target/' + id + '.json'

  getProteinTargetClassification: ->

    target_components = @get('target_components')

    if target_components? and !@get('protein_classifications_loaded')

      @set('protein_classifications', {}, {silent:true})

      target = @

      # step 1: I get the component id of each of the target components
      for comp in target_components
        component_id = comp['component_id']
        comp_url = glados.Settings.WS_BASE_URL + 'target_component/' + component_id + '.json'

        # step 2: I request the details of the current component
        $.get(comp_url).done(

          (data) ->

            protein_classifications = data['protein_classifications']
            for prot_class in protein_classifications

              prot_class_id = prot_class['protein_classification_id']

              # step 3: Now that I got the protein class id, I need to check if it is already there, it can be repeated
              # so I will only make a call when necessary
              prot_class_dict = target.get('protein_classifications')

              if !prot_class_dict[prot_class_id]?
                # I don't have that protein classification, So I need to add it to the dictionary and make a
                # call to get the details
                prot_class_dict[prot_class_id] = ""
                prot_class_url = glados.Settings.WS_BASE_URL + 'protein_class/' + prot_class_id + '.json'


                $.get(prot_class_url).done(
                  (data) ->
                     # now that I have the data I save it
                     prot_class_dict[data['protein_class_id']] = ( data['l' + num] for num in [1..8] when data['l' + num]?  )
                     # By setting this attribute, I prevent that I stay in an infinite loop making requests forever.
                     target.set('protein_classifications_loaded', true, {silent:true})
                     # I make sure to trigger a change event on the target, so the view(s) are informed.
                     # Remember that the information will arrive at any time and in any order, so as soon as there is
                     # one more classification I have to trigger the event. Otherwise the view(s) will not render
                     # the change.
                     target.trigger('change')
                ).fail(
                  () -> console.log('failed2!')
                )


        ).fail(
          () -> console.log('failed!')
        )

  # --------------------------------------------------------------------------------------------------------------------
  # Parsing
  # --------------------------------------------------------------------------------------------------------------------
  parse: (response) ->

    # get data when it comes from elastic
    if response._source?
      objData = response._source
    else
      objData = response

    objData.report_card_url = Target.get_report_card_url(objData.target_chembl_id)
    filterForActivities = 'target_chembl_id:' + objData.target_chembl_id
    objData.activities_url = Activity.getActivitiesListURL(filterForActivities)
    filterForCompounds = '_metadata.related_targets.all_chembl_ids:' + objData.target_chembl_id
    objData.compounds_url = Compound.getCompoundsListURL(filterForCompounds)

    @parseXrefs(objData)
    return objData

  parseXrefs: (objData) ->

    originalRefs = objData.cross_references
    refsIndex = _.indexBy(originalRefs, (item) -> "#{item.xref_src}-#{item.xref_id}")
    targetComponents = objData.target_components

    addXrefToOriginalRefs = (xref, refsIndex, originalRefs) ->

      refIdentifier = "#{xref.xref_src_db}-#{xref.xref_id}"
      xref.xref_src = xref.xref_src_db
      # just in case to avoid duplicates
      if not refsIndex[refIdentifier]?
        originalRefs.push xref
        refsIndex[refIdentifier] = xref

    for component in targetComponents
      componentXrefs = component.target_component_xrefs

      if not componentXrefs?
        continue

      for xref in componentXrefs

        addXrefToOriginalRefs(xref, refsIndex, originalRefs)
        # check if it needs to duplicate it
        if xref.xref_src == 'EnsemblGene'

          newXref = $.extend {}, xref,
            xref_src_db: 'ArrayExpress'
            xref_src_url: 'http://www.ebi.ac.uk/arrayexpress/'
            xref_url: "http://www.ebi.ac.uk/gxa/genes/#{xref.xref_id}"

          addXrefToOriginalRefs(newXref, refsIndex, originalRefs)

          newXref = $.extend {}, xref,
            xref_src_db: 'Human Protein Atlas'
            xref_src_url: 'http://www.proteinatlas.org/'
            xref_url: "http://www.proteinatlas.org/#{xref.xref_id}"

          addXrefToOriginalRefs(newXref, refsIndex, originalRefs)

          newXref = $.extend {}, xref,
            xref_src_db: 'Open Targets'
            xref_src_url: 'https://www.targetvalidation.org/'
            xref_url: "https://www.targetvalidation.org/target/#{xref.xref_id}/associations"

          addXrefToOriginalRefs(newXref, refsIndex, originalRefs)

        if xref.xref_src == 'PDBe'

          newXref = $.extend {}, xref,
            xref_src_db: 'CREDO'
            xref_src_url: 'http://marid.bioc.cam.ac.uk/credo'
            xref_url: "http://marid.bioc.cam.ac.uk/credo/structures/#{xref.xref_id}"

          addXrefToOriginalRefs(newXref, refsIndex, originalRefs)

  fetchFromAssayChemblID: ->

    assayUrl = glados.Settings.WS_BASE_URL + 'assay/' + @get('assay_chembl_id') + '.json'

    thisTarget = @
    $.get(assayUrl).done( (response) ->
      thisTarget.set('target_chembl_id', response.target_chembl_id)
      thisTarget.initURL()
      thisTarget.fetch()
    ).fail(
      () -> console.log('failed!')
    )

# Constant definition for ReportCardEntity model functionalities
_.extend(Target, glados.models.base.ReportCardEntity)
Target.color = 'lime'
Target.reportCardPath = 'target_report_card/'

Target.INDEX_NAME = 'chembl_target'

Target.PROPERTIES_VISUAL_CONFIG = {
  'target_chembl_id': {
    link_base: 'report_card_url'
  },
  'pref_name': {
    custom_field_template: '<i>{{val}}</i>'
  },
  'uniprot_accessions': {
    parse_function: (components) ->

      if not components?
        return glados.Utils.DEFAULT_NULL_VALUE_LABEL

      if components.length == 0
        return glados.Utils.DEFAULT_NULL_VALUE_LABEL

      return (comp.accession for comp in components).join(', ')
    link_function: (components) ->
      'http://www.uniprot.org/uniprot/?query=' + ('accession:' + comp.accession for comp in components).join('+OR+')
  }
  '_metadata.related_compounds.count': {
    link_base: 'compounds_url'
    on_click: TargetReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['target_chembl_id']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    function_key: 'num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
  '_metadata.related_activities.count': {
    link_base: 'activities_url'
    on_click: TargetReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['target_chembl_id']
    function_constant_parameters: ['activities']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    function_key: 'bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  }
}

Target.COLUMNS = {
  CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'target_chembl_id'
    link_base: 'report_card_url'
    hide_label: true
  BIOACTIVITIES_NUMBER: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: '_metadata.related_activities.count'
    link_base: 'activities_url'
    on_click: TargetReportCardApp.initMiniHistogramFromFunctionLink
    function_parameters: ['target_chembl_id']
    function_constant_parameters: ['activities']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    function_key: 'bioactivities'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  PREF_NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'pref_name'
    sort_disabled: true
    custom_field_template: '<i>{{val}}</i>'
  TYPE: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'target_type'
  ORGANISM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'organism'
  ACCESSION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'target_components'
    parse_function: (components) -> (comp.accession for comp in components).join(', ')
    link_function: (components) ->
      'http://www.uniprot.org/uniprot/?query=' + ('accession:' + comp.accession for comp in components).join('+OR+')
  NUM_COMPOUNDS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: '_metadata.related_compounds.count'
    format_class: 'number-cell-center'
    link_base: 'compounds_url'
  NUM_COMPOUNDS_HISTOGRAM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: '_metadata.related_compounds.count'
    link_base: 'compounds_url'
    on_click: TargetReportCardApp.initMiniHistogramFromFunctionLink
    function_constant_parameters: ['compounds']
    function_parameters: ['target_chembl_id']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    function_key: 'num_compounds'
    function_link: true
    execute_on_render: true
    format_class: 'number-cell-center'
  SPECIES_GROUP: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'species_group_flag'
  TAX_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Target.INDEX_NAME,
    comparator: 'tax_id'
  BLAST_EXPECTATION:{
    'show': true
    'name_to_show': 'E-Value'
    'comparator': '_context.best_expectation'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
  POSITIVES_BLAST:{
    'show': true
    'name_to_show': 'Positives %'
    'comparator': '_context.best_positives'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
  IDENTITIES_BLAST:{
    'show': true
    'name_to_show': 'Identities %'
    'comparator': '_context.best_identities'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
  SCORE_BITS_BLAST:{
    'show': true
    'name_to_show': 'Score (bits)'
    'comparator': '_context.best_score_bits'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
  SCORE_BLAST:{
    'show': true
    'name_to_show': 'Score'
    'comparator': '_context.best_score'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
  LENGTH_BLAST:{
    'show': true
    'name_to_show': 'Length'
    'comparator': '_context.length'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'is_contextual': true
  }
}
Target.ID_COLUMN = Target.COLUMNS.CHEMBL_ID

Target.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of Target.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    Target.COLUMNS.CHEMBL_ID
    Target.COLUMNS.PREF_NAME
    Target.COLUMNS.ACCESSION
    Target.COLUMNS.TYPE
    Target.COLUMNS.ORGANISM
    Target.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
    Target.COLUMNS.BIOACTIVITIES_NUMBER
  ]
  RESULTS_LIST_BLAST: [
    Target.COLUMNS.CHEMBL_ID
    Target.COLUMNS.BLAST_EXPECTATION
    Target.COLUMNS.POSITIVES_BLAST
    Target.COLUMNS.IDENTITIES_BLAST
    Target.COLUMNS.SCORE_BITS_BLAST
    Target.COLUMNS.SCORE_BLAST
    Target.COLUMNS.LENGTH_BLAST
    Target.COLUMNS.PREF_NAME
    Target.COLUMNS.ACCESSION
    Target.COLUMNS.TYPE
    Target.COLUMNS.ORGANISM
    Target.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
    Target.COLUMNS.BIOACTIVITIES_NUMBER
  ]
  RESULTS_LIST_ADDITIONAL: [
    Target.COLUMNS.TAX_ID
    Target.COLUMNS.SPECIES_GROUP
  ]
  RESULTS_LIST_REPORT_CARD:[
    Target.COLUMNS.CHEMBL_ID
    Target.COLUMNS.PREF_NAME
    Target.COLUMNS.ACCESSION
    Target.COLUMNS.TYPE
    Target.COLUMNS.ORGANISM
    Target.COLUMNS.NUM_COMPOUNDS
    Target.COLUMNS.BIOACTIVITIES_NUMBER
  ]
}

Target.COLUMNS_SETTINGS.DEFAULT_DOWNLOAD_COLUMNS = _.union(Target.COLUMNS_SETTINGS.RESULTS_LIST_TABLE,
  Target.COLUMNS_SETTINGS.RESULTS_LIST_ADDITIONAL)

Target.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
  COLUMNS: Target.COLUMNS_SETTINGS.RESULTS_LIST_TABLE

Target.getTargetsListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  return glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'targets'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState
