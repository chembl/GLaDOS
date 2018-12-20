describe "Server Side Downloads", ->

  downloadModel = undefined
  esList = undefined
  searchESQuery = JSON.parse('{"bool":{"boost":1,"must":{"bool":{"should":[{"multi_match":{"type":"most_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":10}},{"multi_match":{"type":"best_fields","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","fuzziness":0,"minimum_should_match":"100%","boost":2}},{"multi_match":{"type":"phrase","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%","boost":1.5}},{"multi_match":{"type":"phrase_prefix","fields":["*.std_analyzed^1.6","*.eng_analyzed^0.8","*.ws_analyzed^1.4","*.keyword^2","*.lower_case_keyword^1.5","*.alphanumeric_lowercase_keyword^1.3"],"query":"Aspirin","minimum_should_match":"100%"}},{"multi_match":{"type":"most_fields","fields":["*.entity_id^2","*.id_reference^1.5","*.chembl_id^2","*.chembl_id_reference^1.5"],"query":"Aspirin","fuzziness":0,"boost":10}}],"must":[]}},"filter":[]}}')

  beforeAll (done) ->

    esList = glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict()[\
    glados.models.paginatedCollections.Settings.ES_INDEXES.COMPOUND.KEY_NAME
    ]
    esList.setMeta('searchESQuery', searchESQuery)
    esList.setMeta('test_mode', true)
    TestsUtils.simulateDataESList(esList,
      glados.Settings.STATIC_URL + 'testData/SearchResultsAspirinTestData.json', done)

  beforeEach ->

    downloadModel = new glados.models.ServerSideDownloads.DownloadModel
      collection: esList

  it 'starts at the initial state', ->

    stateMustBe = glados.models.ServerSideDownloads.DownloadModel.states.INITIAL_STATE
    stateGot = downloadModel.getState()
    expect(stateGot).toBe(stateMustBe)

  it 'generates the download params for all items', ->

    desiredFormat = 'CSV'
    requestData = esList.getRequestData()
    downloadParamsGot = downloadModel.getDownloadParams(desiredFormat)

    queryGot = downloadParamsGot.query
    queryMustBe = JSON.stringify(requestData.query)
    expect(queryGot).toBe(queryMustBe)

    indexNameGot = downloadParamsGot.index_name
    indexNameMustBe = esList.getMeta('index_name')
    expect(indexNameGot).toBe(indexNameMustBe)

    formatGot = downloadParamsGot.format
    expect(formatGot).toBe(desiredFormat)

    downloadColumnsMustBe = esList.getMeta('download_columns')
    columnComparatorsMustBe = (col.comparator for col in downloadColumnsMustBe)
    columnLabelsMustBe = (col.name_to_show for col in downloadColumnsMustBe)

    columnsGot = JSON.parse(downloadParamsGot.columns)
    columnComparatorsGot = (col.property_name for col in columnsGot)
    expect(_.isEqual(columnComparatorsGot, columnComparatorsMustBe)).toBe(true)

    columnLabelsGot = (col.label for col in columnsGot)
    expect(_.isEqual(columnLabelsGot, columnLabelsMustBe)).toBe(true)

  it 'generates the params to request the download status', ->

    testDownloadID = 'someDownloadId'
    downloadModel.set('download_id', testDownloadID)
    progressURLGot = downloadModel.getProgressURL()
    progressURLMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}download-progress/#{testDownloadID}"
    expect(progressURLGot).toBe(progressURLMustBe)

  it 'generates the correct download url', ->

    testDownloadID = 'someDownloadId'
    downloadModel.set('download_id', testDownloadID)
    downloadURLMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}dynamic-downloads/#{testDownloadID}.gz"
    downloadURLGot = downloadModel.getDownloadURL()

    expect(downloadURLGot).toBe(downloadURLMustBe)



