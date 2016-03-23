# View that renders the Compound Representations section
# from the compound report card
CompoundRepresentationsView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->

    @renderCanonicalSmiles()
    @renderStandardInchi()
    @renderStandardInchiKey()

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    afterRender()

  renderCanonicalSmiles: ->

    molecule_structures = @model.get('molecule_structures')
    $(@el).find('#CompReps-canonicalSmiles, #CompReps-canonicalSmiles-small').attr('value',
      molecule_structures['canonical_smiles'])

  renderStandardInchi: ->

    molecule_structures = @model.get('molecule_structures')
    $(@el).find('#CompReps-standardInchi, #CompReps-standardInchi-small').attr('value',
      molecule_structures['standard_inchi'])

  renderStandardInchiKey: ->

    molecule_structures = @model.get('molecule_structures')
    $(@el).find('#CompReps-standardInchiKey, #CompReps-standardInchiKey-small').attr('value',
      molecule_structures['standard_inchi_key'])



