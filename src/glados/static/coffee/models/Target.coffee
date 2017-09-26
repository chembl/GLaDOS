Target = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  idAttribute: 'target_chembl_id'

  initialize: ->
    @on 'change', @getProteinTargetClassification, @
    @initURL()

  initURL: ->

    @url = glados.Settings.WS_BASE_URL + 'target/' + @get('target_chembl_id') + '.json'

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

  parse: (data) ->
    parsed = data
    parsed.report_card_url = Target.get_report_card_url(parsed.target_chembl_id)
    filterForActivities = 'target_chembl_id:' + parsed.target_chembl_id
    parsed.activities_url = Activity.getActivitiesListURL(filterForActivities)
    filterForCompounds = '_metadata.related_targets.chembl_ids.\\*:' + parsed.target_chembl_id
    parsed.compounds_url = Compound.getCompoundsListURL(filterForCompounds)
    return parsed;

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

Target.COLUMNS = {
  CHEMBL_ID: {
      'name_to_show': 'CHEMBL_ID'
      'comparator': 'target_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': 'report_card_url'
    }
  BIOACTIVITIES_NUMBER: {
    'name_to_show': 'Bioactivities'
    'comparator': '_metadata.activity_count'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base': 'activities_url'
    'on_click': TargetReportCardApp.initMiniHistogramFromFunctionLink
    'function_parameters': ['target_chembl_id']
    'function_constant_parameters': ['activities']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    'function_key': 'bioactivities'
    'function_link': true
    'execute_on_render': true
    'format_class': 'number-cell-center'
    'secondary_link': true
  }
  PREF_NAME: {
    'name_to_show': 'Name'
    'comparator': 'pref_name'
    'sort_disabled': true
    'custom_field_template': '<i>{{val}}</i>'
  }
  TYPE: {
    'name_to_show': 'Type'
    'comparator': 'target_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ORGANISM:{
    'name_to_show': 'Organism'
    'comparator': 'organism'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ACCESSION:{
    'name_to_show': 'UniProt Accession'
    'comparator': 'target_components.accession'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  NUM_COMPOUNDS:{
    'name_to_show': 'Compounds'
    'comparator': '_metadata.related_compounds.count'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'format_class': 'number-cell-center'
    'secondary_link': true
    'link_base': 'compounds_url'
  }
  NUM_COMPOUNDS_HISTOGRAM: {
    'name_to_show': 'Compounds'
    'comparator': '_metadata.related_compounds.count'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base': 'compounds_url'
    'on_click': TargetReportCardApp.initMiniHistogramFromFunctionLink
    'function_constant_parameters': ['compounds']
    'function_parameters': ['target_chembl_id']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    'function_key': 'num_compounds'
    'function_link': true
    'execute_on_render': true
    'format_class': 'number-cell-center'
    'secondary_link': true
  }
}
Target.ID_COLUMN = Target.COLUMNS.CHEMBL_ID

Target.COLUMNS_SETTINGS = {
  RESULTS_LIST_TABLE: [
    Target.COLUMNS.CHEMBL_ID
    Target.COLUMNS.PREF_NAME
    Target.COLUMNS.ACCESSION
    Target.COLUMNS.TYPE
    Target.COLUMNS.ORGANISM
    Target.COLUMNS.NUM_COMPOUNDS_HISTOGRAM
    Target.COLUMNS.BIOACTIVITIES_NUMBER
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

Target.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
  COLUMNS: Target.COLUMNS_SETTINGS.RESULTS_LIST_TABLE

Target.getTargetsListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'targets/filter/' + encodeURIComponent(filter)
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'targets'
