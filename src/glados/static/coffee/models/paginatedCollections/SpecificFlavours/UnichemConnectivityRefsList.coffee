glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  UnichemConnectivityRefsList:

    setInchiKeys: (keysStructure) -> @setMeta('keys_structure', keysStructure)
    getURLForInchi: (inchiKey) ->

      uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
      return "#{glados.ChemUtils.UniChem.connectivity_url}#{encodeURI(inchiKey)}/0/0/4?callback=#{uCBKey}"

    fetchDataForInchiKey: (inchiKey) ->

      callbackUnichem = (ucJSONResponse) ->

        console.log 'RESPONSE GOT: ', ucJSONResponse
        console.log JSON.stringify(ucJSONResponse)

      uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
      window[uCBKey] = callbackUnichem

      jQueryPromise = $.ajax
        type: 'GET'
        url: @getURLForInchi(inchiKey)
        jsonp: uCBKey
        dataType: 'jsonp'
        headers:
          'Accept':'application/json'

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
