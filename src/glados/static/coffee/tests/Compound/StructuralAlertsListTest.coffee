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

    console.log 'sampleDataToParse: ', sampleDataToParse
    parsedDataGot = structuralAlertsSets.parse(sampleDataToParse)
    console.log 'parsedDataGot: ', parsedDataGot

    structuralAlertsSetsIndex = _.indexBy(parsedDataGot, 'set_name')
    console.log 'structuralAlertsSetsIndex: ', structuralAlertsSetsIndex

    for structAlertMustBe in sampleDataToParse.compound_structural_alerts
      console.log 'structAlert: ', structAlertMustBe
      setName = structAlertMustBe.alert.alert_set.set_name
      console.log 'setName: ', setName
      parsedAlertSet = structuralAlertsSetsIndex[setName]
      console.log 'parsetAlertSet: ', parsedAlertSet
      expect(parsedAlertSet?).toBe(true)
      expect(parsedAlertSet.set_name).toBe(setName)

      alertsList = parsedAlertSet.alerts_list
      expect(alertsList?).toBe(true)
      console.log 'alertsList: ', alertsList
      currentAlertID = structAlertMustBe.cpd_str_alert_id
      console.log 'currentAlertID: ', currentAlertID
      currentAlert = _.find(alertsList, (a) -> a.cpd_str_alert_id == currentAlertID)
      console.log 'currentAlert: ', currentAlert
      expect(currentAlert?).toBe(true)
      expect(currentAlert.molecule_chembl_id).toBe(testChemblID)

      alertNameMustBe = structAlertMustBe.alert.alert_name
      expect(currentAlert.alert_name).toBe(alertNameMustBe)
      console.log '^^^'
