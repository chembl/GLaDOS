glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  UnichemConnectivityRefsList:

    setCompound: (compound) -> @setMeta('original_compound', compound)
    setInchiKeys: (keysStructure) -> @setMeta('keys_structure', keysStructure)
    getURLForInchi: (inchiKey) ->

      uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
      return "#{glados.ChemUtils.UniChem.connectivity_url}#{encodeURI(inchiKey)}/0/0/4?callback=#{uCBKey}"

    #-------------------------------------------------------------------------------------------------------------------
    # Fetching
    #-------------------------------------------------------------------------------------------------------------------
    fetch: ->
      keysStructure = @getMeta('keys_structure')
      parentInchiKey = keysStructure.parent_key
      @fetchDataForInchiKey(parentInchiKey)

    fetchDataForInchiKey: (inchiKey) ->

      thisList = @
      callbackUnichem = (ucJSONResponse) ->

        thisList.setMeta('data_loaded', true)
        thisList.reset(thisList.parse(ucJSONResponse))
        # replace with items ready thing!!!

      uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
      window[uCBKey] = callbackUnichem

      jQueryPromise = $.ajax
        type: 'GET'
        url: @getURLForInchi(inchiKey)
        jsonp: uCBKey
        dataType: 'jsonp'
        headers:
          'Accept':'application/json'

    #-------------------------------------------------------------------------------------------------------------------
    # Parsing
    #-------------------------------------------------------------------------------------------------------------------
    parse: (response) ->

      console.log 'PARSING: ', response
      matchesReceived = response[1]
      parsedMatches = []
      for match in matchesReceived
        console.log 'parsing match: ', match

        parsedMatches.push
          src_name: match.name_label
          scr_url: match.src_URL

      return parsedMatches



glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY = 'UNICHEM_CALLBACK'
