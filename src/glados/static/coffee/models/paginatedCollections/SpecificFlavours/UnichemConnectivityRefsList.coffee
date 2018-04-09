glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  UnichemConnectivityRefsList:

    setInchiKeys: (keysStructure) -> @setMeta('keys_structure', keysStructure)

    getURLForParent: ->
      keysStructure = @getMeta('keys_structure')
      return @getURLForInchi(keysStructure.parent_key)

    getURLForInchi: (inchiKey) -> "#{glados.ChemUtils.UniChem.connectivity_url}#{inchiKey}/0/0/4?callback=xyz"
