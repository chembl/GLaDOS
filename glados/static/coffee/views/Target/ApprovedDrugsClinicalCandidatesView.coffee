# View that renders the Approved drugs and clinical candidates section
# from the target report card
# load CardView first!
ApprovedDrugsClinicalCandidatesView = CardView.extend

  initialize: ->
    @collection.on 'reset', @.render, @

  render: ->

    console.log('render!')
    @fill_table_large()

  fill_table_large: ->

    table = $(@el).find('#ADCCTable-large')
    console.log(table)


    console.log('models!')
    console.log(@collection.models)

    for adcc in @collection.models

      console.log('adding row!')
      new_row_cont = Handlebars.compile( $('#Handlebars-Target-ADCCRow-large').html() )
        molecule_chembl_id: adcc.get('molecule_chembl_id')
        pref_name: adcc.get('pref_name')
        mechanism_of_action: adcc.get('mechanism_of_action')
        max_phase: adcc.get('max_phase')

      table.append($(new_row_cont))

