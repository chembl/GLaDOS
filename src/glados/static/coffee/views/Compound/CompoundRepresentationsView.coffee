# View that renders the Compound Representations section
# from the compound report card
CompoundRepresentationsView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Compound'
    @section_id = arguments[0].section_id

  render: ->
    @molecule_structures = @model.get('molecule_structures')

    if not @molecule_structures?
      CompoundReportCardApp.hideSection(@section_id)
      return

    @renderButtons()
    @renderCanonicalSmiles()
    @renderStandardInchi()
    @renderStandardInchiKey()

    # until here, all the visible content has been rendered.
    @showCardContent()

    @initEmbedModal('representations',  @model.get('molecule_chembl_id'))
    @activateTooltips()
    @activateModals()

    afterRender()

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
        saveAs(blob, compound_model.get('molecule_chembl_id')+'.sdf')
    )

    # Editor button/link
    $openInEditorBtn = $(@el).find('#Reps-Molfile-edit')
    $editorModal = ButtonsHelper.generateModalFromTemplate($openInEditorBtn, 'Handlebars-Common-MarvinModal')

    ButtonsHelper.initLinkButton($openInEditorBtn, 'Open Molecule Editor')
    @marvinEditor = null

    ButtonsHelper.initLinkButton($(@el).find('#Reps-Molfile-edit'), 'Open Molecule Editor', ->
      compound_model.get('get_sdf_content_promise')().done (molfile_data) ->
        if $editorModal.attr('data-marvin-initialised') != 'yes'
          thisView.marvinEditor = new MarvinSketcherView({
            el: $editorModal
            sdf_to_load_on_ready: molfile_data
          })
          marvin_iframe = $(thisView.el).find('.sketch-iframe')
          $($(thisView.el).find('.sketch-iframe'), marvin_iframe.contents()).addClass('border')
          $editorModal.attr('data-marvin-initialised', 'yes')
        else if thisView.marvinEditor?
          thisView.marvinEditor.loadStructure(molfile_data, MarvinSketcherView.SDF_FORMAT)
    )

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



