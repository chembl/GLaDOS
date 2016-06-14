# View that renders the Target Name and Classification section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetNameAndClassificationView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->

    @render_for_large()

    # until here, all the visible content has been rendered.
    @showVisibleContent()



  render_for_large: ->

    table_large = $(@el).find('#BCK-TNC-large')
    template = $('#' + table_large.attr('data-hb-template'))

    table_large.html Handlebars.compile(template.html())
      chembl_id: @model.get('target_chembl_id')
      type: @model.get('target_type')
      pref_name: @model.get('pref_name')
      synonyms: @get_target_syonyms_list(@model.get('target_components'))
      organism: @model.get('organism')
      specs_group: if @model.get('species_group_flag') then 'Yes' else 'No'
      prot_target_classification: 'Enzyme'


  ### *
    * Give me the target_components list from the web services response and I will
    * return a list with the synoyms only.
    * @param {Array} target_components, array of objects from the response.
    * @return {Array} array with the synonyms, it can be empty if there are none
  ###
  get_target_syonyms_list: (target_components) ->
    synonyms = []
    for component in target_components

      for syn_struc in component['target_component_synonyms']

        synonyms.push(syn_struc['component_synonym']) unless syn_struc['syn_type'] == 'EC_NUMBER'

    return synonyms
