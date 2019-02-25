glados.useNameSpace 'glados.models.paginatedCollections',

  ReferenceStructureFunctions:

    initReferenceStructureFunctions: ->

      searchTerm = GlobalVariables.SEARCH_TERM
      if searchTerm.startsWith('CHEMBL')
        @referenceCompound = new Compound
          id: searchTerm

        @referenceCompound.on 'change', @handleReferenceCompoundLoaded, @
        @referenceCompound.on 'error', @handleReferenceCompoundError, @
        @referenceCompound.fetch()
      else
        @setMeta('reference_smiles', searchTerm)

        if @getMeta('enable_substructure_highlighting')
          @loadSubstructureHighlightingRefData()

    handleReferenceCompoundLoaded: ->
      refSmiles = @referenceCompound.get('molecule_structures').canonical_smiles
      @setMeta('reference_smiles', refSmiles)
      @setMeta('reference_smiles_error', false)
      @setMeta('reference_smiles_error_jqxhr', undefined)

      for model in @models
        model.set('reference_smiles', refSmiles)
        model.set('reference_smiles_error', false)
        model.set('reference_smiles_error_jqxhr', undefined)

      @loadSubstructureHighlightingRefData()

    handleReferenceCompoundError: (modelOrCollection, jqXHR) ->

      @setMeta('reference_smiles_error', true)
      @setMeta('reference_smiles_error_jqxhr', jqXHR)

      for model in @models
        model.set('reference_smiles_error', true)
        model.set('reference_smiles_error_jqxhr', jqXHR)

    # ------------------------------------------------------------------------------------------------------------------
    # General Error Handling
    # ------------------------------------------------------------------------------------------------------------------
    setLoadingSpecialStructureError: (jqXHR) ->

      @setMeta('reference_smiles_error', true)
      @setMeta('reference_smiles_error_jqxhr', jqXHR)

      for model in @models
        model.set('reference_smiles_error', true)
        model.set('reference_smiles_error_jqxhr', jqXHR)

    # ------------------------------------------------------------------------------------------------------------------
    # Substructure Highlighting
    # ------------------------------------------------------------------------------------------------------------------
    loadSubstructureHighlightingRefData: ->
      # here I assume that I already have smiles
      @loadReferenceCTAB()

    # ------------------------------------------------------------------------------------------------------------------
    # Reference CTAB
    # ------------------------------------------------------------------------------------------------------------------
    loadReferenceCTAB: ->

      formData = new FormData()
      smilesFileBlob = new Blob([@getMeta('reference_smiles')], {type: 'chemical/x-daylight-smiles'})
      formData.append('file', smilesFileBlob, 'molecule.smi')
      formData.append('sanitize', 0)

      ajaxRequestDict =
        url: glados.Settings.BEAKER_BASE_URL + 'smiles2ctab'
        data: formData
        enctype: 'multipart/form-data'
        processData: false
        contentType: false
        cache: false

      getReferenceCTAB = $.post(ajaxRequestDict)

      getReferenceCTAB.done $.proxy(@handleReferenceCTABLoaded, @)
      getReferenceCTAB.error $.proxy(@handleReferenceCTABError, @)

    handleReferenceCTABError: (jqXHR) -> @setLoadingSpecialStructureError(jqXHR)
    handleReferenceCTABLoaded: (ctab) ->

      @setMeta('reference_ctab', ctab)
      @setMeta('reference_smiles_error', false)
      @setMeta('reference_smiles_error_jqxhr', undefined)

      for model in @models
        model.set('reference_ctab', ctab)
        model.set('reference_smiles_error', false)
        model.set('reference_smiles_error_jqxhr', undefined)

      @loadReferenceSmarts()

    # ------------------------------------------------------------------------------------------------------------------
    # Reference Smarts
    # ------------------------------------------------------------------------------------------------------------------
    loadReferenceSmarts: ->

      formData = new FormData()
      molFileBlob = new Blob([@getMeta('reference_ctab')], {type: 'chemical/x-mdl-molfile'})
      formData.append('file', molFileBlob, 'molecule.mol')
      formData.append('sanitize', 0)

      ajaxRequestDict =
        url: glados.Settings.BEAKER_BASE_URL + 'ctab2smarts'
        data: formData
        enctype: 'multipart/form-data'
        processData: false
        contentType: false
        cache: false

      getReferenceSmarts = $.post(ajaxRequestDict)

      getReferenceSmarts.done $.proxy(@handleReferenceSmartsLoaded, @)
      getReferenceSmarts.error $.proxy(@handleReferenceSmartsError, @)

    handleReferenceSmartsError: (jqXHR) -> @setLoadingSpecialStructureError(jqXHR)
    handleReferenceSmartsLoaded: (smarts) ->

      @setMeta('reference_smarts', smarts)
      @setMeta('reference_smiles_error', false)
      @setMeta('reference_smiles_error_jqxhr', undefined)

      for model in @models
        model.set('reference_smarts', smarts)
        model.set('reference_smiles_error', false)
        model.set('reference_smiles_error_jqxhr', undefined)



