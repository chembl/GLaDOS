glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  UnichemConnectivityRefsList:

    #-------------------------------------------------------------------------------------------------------------------
    # Initialization
    #-------------------------------------------------------------------------------------------------------------------
    initialize: ->
      @setMeta('show_alternate_forms_state',
      glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.ALTERNATIVE_FORMS_STATES\
      .HIDING_ALTERNATIVE_FORMS)
      @setMeta('no_alternative_forms_to_show', true)

    setCompound: (compound) -> @setMeta('original_compound', compound)
    setInchiKey: (key) -> @setMeta('inchi_key', key)
    getURLForInchi: (inchiKey) ->
      return "#{glados.ChemUtils.UniChem.connectivity_url}#{encodeURI(inchiKey)}/0/0/4"

    getUnichemURL: -> @getURLForInchi(@getMeta('inchi_key'))
    #-------------------------------------------------------------------------------------------------------------------
    # Fetching
    #-------------------------------------------------------------------------------------------------------------------
    fetch: ->

      inchiKey = @getMeta('inchi_key')
      @fetchDataForInchiKey(inchiKey)

    fetchDataForInchiKey: (inchiKey) ->

      if glados.isInEBIProdServers()
        @fetchWithoutJSONP(inchiKey)
      else
        @fetchUsingJSONP(inchiKey)

    fetchUsingJSONP: (inchiKey) ->

      thisList = @

      callbackUnichem = (ucJSONResponse) ->
        thisList.setListDataAfterParse(thisList.parse(ucJSONResponse), true)


      uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
      window[uCBKey] = callbackUnichem

      jQueryPromise = $.ajax
        type: 'GET'
        url: @getURLForInchi(inchiKey)
        dataType: "jsonp"
        jsonpCallback: uCBKey
        headers:
          'Accept':'application/json'

    fetchWithoutJSONP: (inchiKey) ->

      thisList = @

      getUnichem = $.get(@getURLForInchi(inchiKey))
      getUnichem.done (ucJSONResponse) ->

        thisList.setListDataAfterParse(thisList.parse(ucJSONResponse), true)

      getUnichem.error (jqXHR)->

        ucJSONResponse = JSON.parse(jqXHR.responseText)
        thisList.setListDataAfterParse(thisList.parse(ucJSONResponse), true)


    #-------------------------------------------------------------------------------------------------------------------
    # Parsing
    #-------------------------------------------------------------------------------------------------------------------
    getInchiMatchClasses: -> @getMeta('inchi_matches')
    setListDataAfterParse: (parsed, dataWasJustReceived=false) ->

      @setMeta('inchi_matches', parsed.inchi_match_classes)
      matchesStructure = parsed.inchi_match_classes
      @setModelsAfterParse(parsed.list, dataWasJustReceived)

    setModelsAfterParse: (rawModelsList, dataWasJustReceived=false) ->

      @setMeta('original_raw_models', rawModelsList)
      modelsToShow = _.filter rawModelsList, (source) ->
        allMatches = source.all_matches
        return _.findWhere(allMatches, {show: true})?

      if ((rawModelsList.length == modelsToShow.length) ) and dataWasJustReceived
        @setMeta('no_alternative_forms_to_show', true)
      else
        @setMeta('no_alternative_forms_to_show', false)

      @reset(modelsToShow)

    parse: (response) ->

      matchesSourcesReceived = response[1]
      parsedSourcesWithMatches = []
      matchClasses = {}
      classNumber = 0
      classPrefix = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.CLASS_PREFIX
      for source in matchesSourcesReceived

        baseItemURL = source.base_id_url

        matches = source.src_matches
        identicalMatches = []
        sMatches = []
        pMatches = []
        iMatches = []
        ipMatches = []
        spMatches = []
        siMatches = []
        sipMatches = []
        allMatches = []

        fullQueryInchi = source['Full Query InChI']
        if not matchClasses[fullQueryInchi]?
          matchClasses[fullQueryInchi] = "#{classPrefix}#{classNumber}"
          classNumber++

        for match in matches

          srcCompoundID = match.src_compound_id
          matchURL = baseItemURL + srcCompoundID

          for compare in match.match_compare

            matchingQueryInchi = compare['Matching_Query_InChI']
            if not matchClasses[matchingQueryInchi]?
              matchClasses[matchingQueryInchi] = "#{classPrefix}#{classNumber}"
              classNumber++

            isToggeable = compare.C > 0
            newRef =
              ref_url: matchURL
              ref_id: srcCompoundID
              is_toggleable: isToggeable
              show: not isToggeable
              colour_class: matchClasses[matchingQueryInchi]

            allMatches.push newRef

            # this logic has been copied from https://github.com/chembl/chembl_interface/blob/master/system/application/views/application/compound/report_card/unichem_connectivity.php
            isS = (parseInt(compare.b) == 1 or parseInt(compare.m) == 1 \
            or parseInt(compare.s) == 1 or parseInt(compare.t) == 1)

            isI = parseInt(compare.i) == 1
            isP = parseInt(compare.p) == 1

            switch
              when (isS and isI and isP) then sipMatches.push(newRef)
              when (isS and isI) then siMatches.push(newRef)
              when (isS and isP) then spMatches.push(newRef)
              when (isI and isP) then ipMatches.push(newRef)
              when (isI) then iMatches.push(newRef)
              when (isP) then pMatches.push(newRef)
              when (isS) then sMatches.push(newRef)
              else identicalMatches.push(newRef)


        parsedSourcesWithMatches.push
          src_name: source.name_label
          scr_url: source.src_URL
          identical_matches: identicalMatches
          s_matches: sMatches
          p_matches: pMatches
          i_matches: iMatches
          ip_matches: ipMatches
          sp_matches: spMatches
          si_matches: siMatches
          sip_matches: sipMatches
          all_matches: allMatches

      return {
        list: parsedSourcesWithMatches
        inchi_match_classes: matchClasses
      }

    #-------------------------------------------------------------------------------------------------------------------
    # Show/hide alternative salts and mixtures
    #-------------------------------------------------------------------------------------------------------------------
    isShowingAlternativeForms: -> @getMeta('show_alternate_forms_state') == \
    glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.ALTERNATIVE_FORMS_STATES\
      .SHOWING_ALTERNATIVE_FORMS

    setIsShowingAlternativeFormsState: (showing) ->
      if showing
        @setMeta('show_alternate_forms_state',
        glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.ALTERNATIVE_FORMS_STATES\
          .SHOWING_ALTERNATIVE_FORMS)
      else
        @setMeta('show_alternate_forms_state',
        glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.ALTERNATIVE_FORMS_STATES\
          .HIDING_ALTERNATIVE_FORMS)

    thereAreNoAlternateFormsToShow: -> @getMeta('no_alternative_forms_to_show')
    toggleAlternativeSaltsAndMixtures: ->

      originalRawModels = @getMeta('original_raw_models')
      newState = not @isShowingAlternativeForms()
      for source in originalRawModels
        allMatches = source.all_matches
        for match in allMatches
          if match.is_toggleable
            match.show = newState

      @setIsShowingAlternativeFormsState(newState)
      @setModelsAfterParse(originalRawModels)



glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY = 'UNICHEM_CALLBACK'
glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.ALTERNATIVE_FORMS_STATES =
  SHOWING_ALTERNATIVE_FORMS: 'SHOWING_ALTERNATIVE_FORMS'
  HIDING_ALTERNATIVE_FORMS: 'HIDING_ALTERNATIVE_FORMS'

glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.CLASS_PREFIX = 'class'