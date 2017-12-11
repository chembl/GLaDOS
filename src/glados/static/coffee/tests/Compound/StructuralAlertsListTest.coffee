describe 'Compound Structural Alerts', ->

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL457419'
    structuralAlertsSets = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewStructuralAlertsSetsList()
    structuralAlertsSets.initURL(testChemblID)

    urlMustBe = "#{glados.Settings.WS_BASE_URL}compound_structural_alert.json?molecule_chembl_id=#{testChemblID}&limit=10000"
    urlGot = structuralAlertsSets.url

    expect(urlMustBe).toBe(urlGot)

  sampleDataToParse = undefined

  testChemblID = undefined
  structuralAlertsSets = undefined

  beforeAll (done) ->

    testChemblID = 'CHEMBL457419'
    structuralAlertsSets = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewStructuralAlertsSetsList()
    structuralAlertsSets.initURL(testChemblID)

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/StructuralAlerts/sampleDataToParseCHEMBL457419.json'
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'parses the data correctly', ->

    parsedDataGot = structuralAlertsSets.parse(sampleDataToParse)
    structuralAlertsSetsIndex = _.indexBy(parsedDataGot, 'set_name')

    for structAlertMustBe in sampleDataToParse.compound_structural_alerts

      setName = structAlertMustBe.alert.alert_set.set_name
      parsedAlertSet = structuralAlertsSetsIndex[setName]
      priorityMustBe = structAlertMustBe.alert.alert_set.priority
      expect(parsedAlertSet?).toBe(true)
      expect(parsedAlertSet.set_name).toBe(setName)
      expect(parsedAlertSet.priority).toBe(priorityMustBe)

      alertsList = parsedAlertSet.alerts_list
      expect(alertsList?).toBe(true)
      currentAlertID = structAlertMustBe.cpd_str_alert_id
      currentAlert = _.find(alertsList, (a) -> a.cpd_str_alert_id == currentAlertID)
      expect(currentAlert?).toBe(true)
      expect(currentAlert.molecule_chembl_id).toBe(testChemblID)

      alertNameMustBe = structAlertMustBe.alert.alert_name
      expect(currentAlert.alert_name).toBe(alertNameMustBe)

      smartsMustBe = structAlertMustBe.alert.smarts
      expect(currentAlert.smarts).toBe(smartsMustBe)

  it 'sorts the rows by priority by default', ->

    parsedDataGot = structuralAlertsSets.parse(sampleDataToParse)

    previousPriority = Number.MAX_SAFE_INTEGER
    for structAlertSetGot in parsedDataGot
      currentPriority = structAlertSetGot.priority
      expect(currentPriority <= previousPriority).toBe(true)
      previousPriority = currentPriority




