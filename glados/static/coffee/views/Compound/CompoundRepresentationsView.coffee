# View that renders the Compound Representations section
# from the compound report card
CompoundRepresentationsView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->
    @molecule_structures = @model.get('molecule_structures')

    if not @molecule_structures?
      $('#CompoundRepresentations').hide()
      return

    @renderCanonicalSmiles()
    @renderStandardInchi()
    @renderStandardInchiKey()

    # until here, all the visible content has been rendered.
    @showVisibleContent()

    @initEmbedModal('representations')
    @activateTooltips()
    @activateModals()

    afterRender()

  renderCanonicalSmiles: ->
    $(@el).find('#CompReps-canonicalSmiles, #CompReps-canonicalSmiles-small').attr('value',
      @molecule_structures['canonical_smiles'])

    ButtonsHelper.initDownloadBtn($(@el).find('#CompReps-canonicalSmiles-dnld, #CompReps-canonicalSmiles-small-dnld'),
      GlobalVariables.CHEMBL_ID + '.smi', 'Download SMILES file.',
      @molecule_structures['canonical_smiles'] + '%20'+ @model.get('molecule_chembl_id'))

    copy_btn = $(@el).find('#CompReps-canonicalSmiles-copy, #CompReps-canonicalSmiles-small-copy')
    ButtonsHelper.initCopyButton(copy_btn, 'Copy to Clipboard', @molecule_structures['canonical_smiles'])

  renderStandardInchi: ->
    $(@el).find('#CompReps-standardInchi, #CompReps-standardInchi-small').attr('value',
      @molecule_structures['standard_inchi'])

    ButtonsHelper.initDownloadBtn($(@el).find('#CompReps-standardInchi-dnld, #CompReps-standardInchi-small-dnld'),
      GlobalVariables.CHEMBL_ID + '-INCHI.txt', 'Download InChI.', @molecule_structures['standard_inchi'])

    copy_btn = $(@el).find('#CompReps-standardInchi-copy, #CompReps-standardInchi-small-copy')
    ButtonsHelper.initCopyButton(copy_btn, 'Copy to Clipboard', @molecule_structures['standard_inchi'])

  renderStandardInchiKey: ->
    $(@el).find('#CompReps-standardInchiKey, #CompReps-standardInchiKey-small').attr('value',
      @molecule_structures['standard_inchi_key'])

    ButtonsHelper.initDownloadBtn($(@el).find('#CompReps-standardInchiKey-dnld, #CompReps-standardInchiKey-small-dnld'),
      GlobalVariables.CHEMBL_ID + '-INCHI_KEY.txt', 'Download InChI Key.', @molecule_structures['standard_inchi_key'])

    copy_btn = $(@el).find('#CompReps-standardInchiKey-copy, #CompReps-standardInchiKey-small-copy')
    ButtonsHelper.initCopyButton(copy_btn, 'Copy to Clipboard', @molecule_structures['standard_inchi_key'])



