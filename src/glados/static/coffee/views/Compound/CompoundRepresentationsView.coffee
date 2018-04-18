# View that renders the Compound Representations section
# from the compound report card
CompoundRepresentationsView = CardView.extend

  initialize: ->
    CardView.prototype.initialize.call(@, arguments)
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'

  render: ->
    @molecule_structures = @model.get('molecule_structures')

    if not @molecule_structures?
      @hideSection()
      return

    @showSection()
    @renderButtons()
    @renderCanonicalSmiles()
    @renderStandardInchi()
    @renderStandardInchiKey()

    # until here, all the visible content has been rendered.
    @showCardContent()

    @initEmbedModal('representations',  @model.get('molecule_chembl_id'))
    @activateTooltips()
    @activateModals()

  renderButtons: ->
    compound_model = @model
    thisView = @
    # Requests the ajax here to avoid conflict with the copy to clipboard
    @model.get('get_sdf_content_promise')().done( )

    # View Raw button/link
    raw_modal = $(@el).find('#SDF-raw-modal')
    raw_modal_title = $(@el).find('#SDF-raw-modal-title')
    raw_modal_content = $(@el).find('.SDF-raw-modal-content')
    ButtonsHelper.initLinkButton($(@el).find('#Reps-Molfile-rawview,#Reps-Molfile-rawview-small'), 'View Raw SDF File', ->
      compound_model.get('get_sdf_content_promise')().done (molfile_data) ->
        raw_modal_title.text(compound_model.get('molecule_chembl_id'))
        raw_modal_content.html(molfile_data.replace(/[\n\r]/g,'<br/>'))
    )
    # Download button/link
    ButtonsHelper.initLinkButton($(@el).find('#Reps-Molfile-dnld,#Reps-Molfile-dnld-small'), 'Download SDF File', ->
      compound_model.get('get_sdf_content_promise')().done (molfile_data) ->
        blob = new Blob([molfile_data], {type: "chemical/x-mdl-sdfile;charset=utf-8"})
        saveAs(blob, compound_model.get('molecule_chembl_id')+'.sdf') unless glados.JS_TEST_MODE
    )

    # Editor button/link
    thisModel = @model
    openEditorCallBack = ->
      glados.helpers.ChemicalEditorHelper.showChemicalEditorModal(undefined, thisModel)

    ButtonsHelper.initLinkButton($(@el).find('#Reps-Molfile-edit'), 'Open Molecule Editor', -> openEditorCallBack())

    ButtonsHelper.initLinkButton($(@el).find('#Reps-Molfile-edit-small'), 'Open Molecule Editor', ->
      compound_model.get('get_sdf_content_promise')().done (molfile_data) ->
        window.sessionStorage.setItem('molfile_data',molfile_data)
        window.location.href = glados.Settings.MARVIN_FULL_SCREEN_PAGE
    )

    # Copy to clipboard button/link
    copy_button_elem = $(@el).find('#Reps-Molfile-copy')
    ButtonsHelper.initLinkButton(copy_button_elem, 'Copy SDF File to clipboard', ->
      compound_model.get('get_sdf_content_promise')().done (molfile_data) ->
        ButtonsHelper.handleCopyDynamic(copy_button_elem, molfile_data)
    )
    copy_button_elem_small = $(@el).find('#Reps-Molfile-copy-small')
    ButtonsHelper.initLinkButton(copy_button_elem_small, 'Copy SDF File to clipboard', ->
      compound_model.get('get_sdf_content_promise')().done (molfile_data) ->
        ButtonsHelper.handleCopyDynamic(copy_button_elem_small, molfile_data)
    )

  renderCanonicalSmiles: ->

    $containerElem = $(@el).find('.BCK-CanonicalSmiles')

    config =
      value: @molecule_structures['canonical_smiles']
      download:
        filename: "#{@model.get('molecule_chembl_id')}.smi"
        value: "#{@molecule_structures['canonical_smiles'] + '%20'+ @model.get('molecule_chembl_id')}"
        tooltip: 'Download SMILES file.'

    ButtonsHelper.initCroppedContainer($containerElem, config)

    $containerElemSmall = $(@el).find('.BCK-CanonicalSmiles-Small')
    ButtonsHelper.initCroppedContainer($containerElemSmall, config)

  renderStandardInchi: ->

    $containerElem = $(@el).find('.BCK-StandardInchi')

    config =
      value: @molecule_structures['standard_inchi']
      download:
        filename: "#{@model.get('molecule_chembl_id')}-INCHI.txt"
        value: "#{@molecule_structures['standard_inchi']}%20#{@model.get('molecule_chembl_id')}"
        tooltip: 'Download INCHI file.'

    ButtonsHelper.initCroppedContainer($containerElem, config)

    $containerElemSmall = $(@el).find('.BCK-StandardInchi-Small')
    ButtonsHelper.initCroppedContainer($containerElemSmall, config)

  renderStandardInchiKey: ->

    $containerElem = $(@el).find('.BCK-StandardInchiKey')

    config =
      value: @molecule_structures['standard_inchi_key']
      download:
        filename: "#{@model.get('molecule_chembl_id')}-INCHI_Key.txt"
        value: "#{@molecule_structures['standard_inchi_key']}%20#{@model.get('molecule_chembl_id')}"
        tooltip: 'Download INCHI Key file.'

    ButtonsHelper.initCroppedContainer($containerElem, config)

    $containerElemSmall = $(@el).find('.BCK-StandardInchiKey-Small')
    ButtonsHelper.initCroppedContainer($containerElemSmall, config)

