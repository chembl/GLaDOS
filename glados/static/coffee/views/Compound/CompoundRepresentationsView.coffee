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

    ButtonsHelper.initDownloadBtn($(@el).find('#CompReps-canonicalSmiles-dnld, #CompReps-canonicalSmiles-small-dnld'),
      CHEMBL_ID + '.smi', 'Download SMILES file.',
      @molecule_structures['canonical_smiles'] + '%20'+ @model.get('molecule_chembl_id'))

  renderStandardInchi: ->
    $(@el).find('#CompReps-standardInchi, #CompReps-standardInchi-small').attr('value',
      @molecule_structures['standard_inchi'])

    ButtonsHelper.initDownloadBtn($(@el).find('#CompReps-standardInchi-dnld, #CompReps-standardInchi-small-dnld'),
      CHEMBL_ID + '-INCHI.txt', 'Download InChI.', @molecule_structures['standard_inchi'])

  renderStandardInchiKey: ->
    $(@el).find('#CompReps-standardInchiKey, #CompReps-standardInchiKey-small').attr('value',
      @molecule_structures['standard_inchi_key'])

    ButtonsHelper.initDownloadBtn($(@el).find('#CompReps-standardInchiKey-dnld, #CompReps-standardInchiKey-small-dnld'),
      CHEMBL_ID + '-INCHI_KEY.txt', 'Download InChI Key.', @molecule_structures['standard_inchi_key'])




