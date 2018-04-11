describe 'Unichem Connectivity List', ->

  list = undefined
  #CHEMBL2296002
  inchiKey = 'JJBCTCGUOQYZHK-ZSCHJXSPSA-N'
  parentDataToParse = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
    # this will be done directly from the info in the compounds
    list.setInchiKey inchiKey

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

    parsedData = list.parse(parentDataToParse)
    sourcesGotIndex = _.indexBy(parsedData, 'src_name')

    for sourceMustBe in parentDataToParse[1]

      nameMustBe = sourceMustBe.name_label
      sourceGot = sourcesGotIndex[nameMustBe]
      mustBeVsGot =
        "#{sourceMustBe.name_label}": sourceGot.src_name
        "#{sourceMustBe.src_URL}": sourceGot.scr_url

      for mustBe, got of mustBeVsGot
        expect(got).toBe(mustBe)

  it 'parses the response from the parent correctly (match classification)', ->

    parsedData = list.parse(parentDataToParse)
    sourcesGotIndex = _.indexBy(parsedData, 'src_name')

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


  it 'parses the response from the parent correctly (toggleability)', ->

    parsedData = list.parse(parentDataToParse)
    sourcesGotIndex = _.indexBy(parsedData, 'src_name')
    console.log 'parsedData: ', parsedData

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
          expect(refGot.show).toBe(false)