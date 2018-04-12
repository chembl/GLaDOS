describe 'Unichem Connectivity List', ->

  list = undefined
  #CHEMBL2296002
  inchiKey = 'JJBCTCGUOQYZHK-ZSCHJXSPSA-N'
  parentDataToParse = undefined

  beforeEach ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
    # this will be done directly from the info in the compounds
    list.setInchiKey inchiKey

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/UnichemConnectivity/JJBCTCGUOQYZHK-ZSCHJXSPSA-N_UnichemResponseToParse.json'
    $.get dataURL, (testData) ->
      parentDataToParse = testData
      done()

  it 'initialises the links correctly', ->

    uCBKey = glados.models.paginatedCollections.SpecificFlavours.UnichemConnectivityRefsList.UNICHEM_CALLBACK_KEY
    urlMustBe = "#{glados.ChemUtils.UniChem.connectivity_url}#{inchiKey}/0/0/4?callback=#{uCBKey}"
    urlGot = list.getURLForInchi(inchiKey)

    expect(urlGot).toBe(urlMustBe)

  it 'parses the response from the parent correctly (source urls)', ->

    parsedList = list.parse(parentDataToParse).list
    sourcesGotIndex = _.indexBy(parsedList, 'src_name')

    for sourceMustBe in parentDataToParse[1]

      nameMustBe = sourceMustBe.name_label
      sourceGot = sourcesGotIndex[nameMustBe]
      mustBeVsGot =
        "#{sourceMustBe.name_label}": sourceGot.src_name
        "#{sourceMustBe.src_URL}": sourceGot.scr_url

      for mustBe, got of mustBeVsGot
        expect(got).toBe(mustBe)

  it 'parses the response from the parent correctly (match classification)', ->

    parsedList = list.parse(parentDataToParse).list
    sourcesGotIndex = _.indexBy(parsedList, 'src_name')

    for sourceMustBe in parentDataToParse[1]

      baseItemURLMustBe = sourceMustBe.base_id_url
      matchesMustBe = sourceMustBe.src_matches
      nameMustBe = sourceMustBe.name_label
      sourceGot = sourcesGotIndex[nameMustBe]

      identicalMatchesGot = sourceGot.identical_matches
      sMatchesGot = sourceGot.s_matches
      pMatchesGot = sourceGot.p_matches
      iMatchesGot = sourceGot.i_matches
      ipMatchesGot = sourceGot.ip_matches
      spMatchesGot = sourceGot.sp_matches
      siMatchesGot = sourceGot.si_matches
      sipMatchesGot = sourceGot.sip_matches
      allMatchesGot = sourceGot.all_matches

      for matchMustBe in matchesMustBe

        srcCompoundIDMustBe = matchMustBe.src_compound_id
        matchURLMustBe = baseItemURLMustBe + srcCompoundIDMustBe

        for compareMustBe in matchMustBe.match_compare

          refURLMustBe = matchURLMustBe
          refIDMustBe = srcCompoundIDMustBe

          isS = (parseInt(compareMustBe.b) == 1 or parseInt(compareMustBe.m) == 1 \
          or parseInt(compareMustBe.s) == 1 or parseInt(compareMustBe.t) == 1)

          isI = parseInt(compareMustBe.i) == 1
          isP = parseInt(compareMustBe.p) == 1

          refGot = switch
              when (isS and isI and isP) then _.find(sipMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              when (isS and isI) then _.find(siMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              when (isS and isP) then _.find(spMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              when (isI and isP) then _.find(ipMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              when (isI) then _.find(iMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              when (isP) then _.find(pMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              when (isS) then _.find(sMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
              else _.find(identicalMatchesGot, (ref) -> ref.ref_id == refIDMustBe)

          expect(refGot?).toBe(true)
          expect(refGot.ref_id).toBe(refIDMustBe)
          expect(refGot.ref_url).toBe(refURLMustBe)

          #expect to always find it in all matches
          refGot2 = _.find(allMatchesGot, (ref) -> ref.ref_id == refIDMustBe)
          expect(refGot2?).toBe(true)
          expect(refGot2.ref_id).toBe(refIDMustBe)
          expect(refGot2.ref_url).toBe(refURLMustBe)



  it 'parses the response from the parent correctly (toggleability)', ->

    parsedList = list.parse(parentDataToParse).list
    sourcesGotIndex = _.indexBy(parsedList, 'src_name')

    for sourceMustBe in parentDataToParse[1]

      matchesMustBe = sourceMustBe.src_matches
      nameMustBe = sourceMustBe.name_label
      sourceGot = sourcesGotIndex[nameMustBe]

      allMatches = _.union(sourceGot.identical_matches, sourceGot.identical_matches, sourceGot.s_matches,
        sourceGot.p_matches, sourceGot.i_matches, sourceGot.ip_matches, sourceGot.sp_matches, sourceGot.si_matches,
        sourceGot.sip_matches)

      for matchMustBe in matchesMustBe

        srcCompoundIDMustBe = matchMustBe.src_compound_id

        for compareMustBe in matchMustBe.match_compare

          refIDMustBe = srcCompoundIDMustBe
          isToggleable = compareMustBe.C > 0

          refGot = _.find(allMatches, (ref) -> ref.ref_id == refIDMustBe)
          expect(refGot?).toBe(true)
          expect(refGot.is_toggleable).toBe(isToggleable)
          expect(refGot.show).toBe(not isToggleable)

  it 'parses the response from the parent correctly (colours)', ->

    parsedData = list.parse(parentDataToParse)
    parsedList = parsedData.list
    sourcesGotIndex = _.indexBy(parsedList, 'src_name')

    # first, calculate how the classes must be
    matchClassesMustBe = {}
    classNumber = 0
    for sourceMustBe in parentDataToParse[1]

      fullQueryInchi = sourceMustBe['Full Query InChI']
      if not matchClassesMustBe[fullQueryInchi]?
        matchClassesMustBe[fullQueryInchi] = "class#{classNumber}"
        classNumber++

      matchesMustBe = sourceMustBe.src_matches
      for matchMustBe in matchesMustBe

        for compareMustBe in matchMustBe.match_compare

          matchingQueryInchi = compareMustBe['Matching_Query_InChI']
          if not matchClassesMustBe[matchingQueryInchi]?
            matchClassesMustBe[matchingQueryInchi] = "class#{classNumber}"
            classNumber++

    # and check that the macthes are correct
    list.setListDataAfterParse(parsedData)
    matchesGot = list.getInchiMatchClasses()
    expect(_.isEqual(matchesGot, matchClassesMustBe)).toBe(true)

    # now check if the classes are correct for every match
    for sourceMustBe in parentDataToParse[1]

      matchesMustBe = sourceMustBe.src_matches
      nameMustBe = sourceMustBe.name_label
      sourceGot = sourcesGotIndex[nameMustBe]

      allMatches = _.union(sourceGot.identical_matches, sourceGot.identical_matches, sourceGot.s_matches,
        sourceGot.p_matches, sourceGot.i_matches, sourceGot.ip_matches, sourceGot.sp_matches, sourceGot.si_matches,
        sourceGot.sip_matches)

      for matchMustBe in matchesMustBe

        srcCompoundIDMustBe = matchMustBe.src_compound_id

        for compareMustBe in matchMustBe.match_compare

          refIDMustBe = srcCompoundIDMustBe
          matchingQueryInchi = compareMustBe['Matching_Query_InChI']
          refGot = _.find(allMatches, (ref) -> ref.ref_id == refIDMustBe)
          classMustBe = matchClassesMustBe[matchingQueryInchi]
          classGot = refGot.colour_class
          expect(classGot).toBe(classMustBe)

  it 'gives only the rows that are not empty', ->

    parsedData = list.parse(parentDataToParse)
    list.setListDataAfterParse(parsedData)
    modelsToShow = list.models
    for model in modelsToShow
      allMatches = model.get('all_matches')
      expect(_.find(allMatches, (match) -> match.show)?).toBe(true)

  it 'toggles the inclusion of salts and mixtures', ->

    parsedData = list.parse(parentDataToParse)
    console.log 'parentDataToParse: ', parentDataToParse
    list.setListDataAfterParse(parsedData)
    expect(list.isShowingAlternativeForms()).toBe(false)

    list.toggleAlternativeSaltsAndMixtures()
    # now everything is shown

    originalRawModels = list.getMeta('original_raw_models')
    modelsToShow = list.models
    modelsAttributes = (m.attributes for m in modelsToShow)
    expect(_.isEqual(originalRawModels, modelsAttributes)).toBe(true)

    list.toggleAlternativeSaltsAndMixtures()
    # now alternative salts are hidden
    modelsToShow = list.models
    modelsAttributes = (m.attributes for m in modelsToShow)

    expect(modelsAttributes.length < originalRawModels.length).toBe(true)

    modelsToShowLengthMustBe = 0

    _.map originalRawModels, (rawModel) ->

      allMatches = rawModel.all_matches
      isShown = _.find(allMatches, (match) -> match.show)?
      if isShown
        modelsToShowLengthMustBe++

    expect(modelsToShowLengthMustBe).toBe(modelsAttributes.length)

    for model in modelsToShow
      allMatches = model.get('all_matches')
      expect(_.find(allMatches, (match) -> match.show)?).toBe(true)
