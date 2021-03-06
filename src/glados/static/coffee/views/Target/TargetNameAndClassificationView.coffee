# View that renders the Target Name and Classification section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetNameAndClassificationView = CardView.extend

  initialize: ->

    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Target'
    @showSection()

  render: ->

    @fillTemplate('BCK-TNC-large')
    @fillTemplate('BCK-TNC-small')

    # until here, all the visible content has been rendered.
    @showCardContent()
    @initEmbedModal('name_and_classification', @model.get('target_chembl_id'))
    @activateModals()

  fillTemplate: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    target_classifications = []

    $.map(@model.get('protein_classifications'), (val, key) -> target_classifications.push(val))

    div.html Handlebars.compile(template.html())
      chembl_id: @model.get('target_chembl_id')
      type: @model.get('target_type')
      pref_name: @model.get('pref_name')
      synonyms: @get_target_syonyms_list(@model.get('target_components'))
      organism: @model.get('organism')
      specs_group: if @model.get('species_group_flag') then 'Yes' else 'No'
      prot_target_classifications: target_classifications

  ### *
    * Give me the target_components list from the web services response and I will
    * return a list with the synoyms only.
    * @param {Array} target_components, array of objects from the response.
    * @return {Array} array with the synonyms, if there are none the list will be empty
  ###
  get_target_syonyms_list: (target_components) ->
    synonyms = []
    for component in target_components

      for syn_struc in component['target_component_synonyms']

        if syn_struc['component_synonym']?
          synonyms.push(syn_struc['component_synonym']) unless syn_struc['syn_type'] == 'EC_NUMBER'

    return _.unique(synonyms)