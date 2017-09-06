glados.useNameSpace 'glados.models.paginatedCollections',

  SimilarityMapFunctions:

    initSimilarityMapFunctions: ->
      console.log 'similarity maps enabled!'
      searchTerm = @getMeta('search_term')
      if searchTerm.startsWith('CHEMBL')
        console.log 'need to get smiles!!'
        @referenceCompound = new Compound
          id: searchTerm + 'bla bla bla'

        f = $.proxy(@handleReferenceCompoundLoaded, @)
        f2 = $.proxy(@handleReferenceCompoundError, @)
        @referenceCompound.on 'change', (-> setTimeout(f, 400)), @
        @referenceCompound.on 'error', @handleReferenceCompoundError, @
        @referenceCompound.fetch()
      else
        console.log 'already got smiles!'
        @setMeta('reference_smiles', searchTerm)

    handleReferenceCompoundLoaded: ->
      refSmiles = @referenceCompound.get('molecule_structures').canonical_smiles
      @setMeta('reference_smiles', refSmiles)
      model.set('reference_smiles_error', false)
      @setMeta('reference_smiles_error_jqxhr', undefined)
      console.log('AAA handleReferenceCompoundLoaded!', @getMeta('reference_smiles'))

      for model in @models
        model.set('reference_smiles', refSmiles)
        model.set('reference_smiles_error', false)
        @setMeta('reference_smiles_error_jqxhr', undefined)
        console.log 'AAA updating model!'

    handleReferenceCompoundError: (modelOrCollection, jqXHR) ->
      @setMeta('reference_smiles_error', true)
      @setMeta('reference_smiles_error_jqxhr', jqXHR)

      console.log 'AAA handleReferenceCompoundError'
      console.log 'AAA response ', jqXHR
      for model in @models
        model.set('reference_smiles_error', true)
        @setMeta('reference_smiles_error_jqxhr', jqXHR)
        console.log 'AAA updating model!'