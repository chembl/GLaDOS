# View that renders the Compound Representations section
# from the compound report card
CompoundRepresentationsView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @

  render: ->

    @molecule_structures = @model.get('molecule_structures')

    if not @molecule_structures?
      $('#CompoundRepresentations').hide()
      return

    @renderCanonicalSmiles()
    @renderStandardInchi()
    @renderStandardInchiKey()

    # until here, all the visible content has been rendered.
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error)').show()

    @initEmbedModal('representations')
    @renderModalPreview()
    @activateTooltips()
    @activateModals()

    afterRender()

  renderCanonicalSmiles: ->


    $(@el).find('#CompReps-canonicalSmiles, #CompReps-canonicalSmiles-small').attr('value',
      @molecule_structures['canonical_smiles'])

  renderStandardInchi: ->

    $(@el).find('#CompReps-standardInchi, #CompReps-standardInchi-small').attr('value',
      @molecule_structures['standard_inchi'])

  renderStandardInchiKey: ->

    $(@el).find('#CompReps-standardInchiKey, #CompReps-standardInchiKey-small').attr('value',
      @molecule_structures['standard_inchi_key'])



