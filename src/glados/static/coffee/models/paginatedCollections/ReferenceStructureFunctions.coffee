glados.useNameSpace 'glados.models.paginatedCollections',

  ReferenceStructureFunctions:

    initReferenceStructureFunctions: ->
      searchTerm = @getMeta('search_term')
      if searchTerm.startsWith('CHEMBL')
        @referenceCompound = new Compound
          id: searchTerm

        @referenceCompound.on 'change', @handleReferenceCompoundLoaded, @
        @referenceCompound.on 'error', @handleReferenceCompoundError, @
        @referenceCompound.fetch()
      else
        @setMeta('reference_smiles', searchTerm)

    handleReferenceCompoundLoaded: ->
      refSmiles = @referenceCompound.get('molecule_structures').canonical_smiles
      @setMeta('reference_smiles', refSmiles)
      @setMeta('reference_smiles_error', false)
      @setMeta('reference_smiles_error_jqxhr', undefined)

      for model in @models
        model.set('reference_smiles', refSmiles)
        model.set('reference_smiles_error', false)
        @setMeta('reference_smiles_error_jqxhr', undefined)

    handleReferenceCompoundError: (modelOrCollection, jqXHR) ->

      @setMeta('reference_smiles_error', true)
      @setMeta('reference_smiles_error_jqxhr', jqXHR)

      for model in @models
        model.set('reference_smiles_error', true)
        @setMeta('reference_smiles_error_jqxhr', jqXHR)

    toggleShowSpecialStructure: (active) ->

      if @getMeta('enable_similarity_maps')
        @showStructurePropName = 'show_similarity_map'
      else if @getMeta('enable_substructure_highlighting')
        @showStructurePropName = 'show_substructure_highlighting'

      active ?= not @getMeta(@showStructurePropName)
      @setMeta(@showStructurePropName, active)
      for model in @models
        model.set(@showStructurePropName, active)

