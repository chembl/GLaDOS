# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @
    @resource_type = 'Target'

  render: ->

    @fill_template('ADCCTable-large')
    @fill_template('ADCCUL-small')

    @showVisibleContent()

  fill_template: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    for adcc in @collection.models

      new_row_cont = Handlebars.compile( template.html() )
        molecule_chembl_id: adcc.get('molecule_chembl_id')
        pref_name: adcc.get('pref_name')
        mechanism_of_action: adcc.get('mechanism_of_action')
        max_phase: adcc.get('max_phase')

      div.append($(new_row_cont))

