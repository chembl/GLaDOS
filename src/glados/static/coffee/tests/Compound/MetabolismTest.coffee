describe 'Compound Metabolism', ->

  parsedDataMustBe = undefined
  sampleDataToParse = undefined

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/Metabolism/metabolismSampleParsedData.json'
    $.get dataURL, (testData) ->
      parsedDataMustBe = testData
      done()

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/Metabolism/sampleDataToParse.json'
    $.get dataURL, (testData) ->
      sampleDataToParse = testData
      done()

  it 'Sets up the url correctly', ->

    testChemblID = 'CHEMBL25'
    compoundMetabolism = new glados.models.Compound.Metabolism
      molecule_chembl_id: testChemblID

    urlMustBe = glados.models.paginatedCollections.Settings.ES_BASE_URL +
      '/chembl_metabolism/_search?q=_metadata.all_graph_chembl_ids:' + testChemblID + '&size=10000'
    console.log 'URL: ', compoundMetabolism.url
    expect(compoundMetabolism.url).toBe(urlMustBe)

  it 'parses the nodes correctly', ->

    testChemblID = 'CHEMBL25'
    compoundMetabolism = new glados.models.Compound.Metabolism
      molecule_chembl_id: testChemblID

    parsedData = compoundMetabolism.parse(sampleDataToParse)
    nodesMustBe = parsedDataMustBe.graph.nodes
    nodesGot = parsedData.graph.nodes
    nodesGotIndex = _.indexBy(nodesGot, 'chembl_id')
    for nodeMustBe in nodesMustBe
      nodeID = nodeMustBe.chembl_id
      nodeGot = nodesGotIndex[nodeID]
      expect(nodeGot?).toBe(true)
      expect(nodeGot.is_current).toBe(nodeID == testChemblID)
      #for the pref name, the fields 'metabolite_name', and substrate_name were added to the response
      # https://github.com/chembl/chembl_webservices_2/issues/150
#      expect(nodeGot.pref_name).toBe(nodeMustBe.pref_name)

  it 'parses the edges correctly', ->

    testChemblID = 'CHEMBL25'
    compoundMetabolism = new glados.models.Compound.Metabolism
      molecule_chembl_id: testChemblID

    parsedData = compoundMetabolism.parse(sampleDataToParse)
    console.log 'parsedData: ', parsedData

    nodesGot = parsedData.graph.nodes
    nodesMustBe = parsedDataMustBe.graph.nodes
    edgesMustBe = parsedDataMustBe.graph.edges
    edgesGot = parsedData.graph.edges

    edgesGotIndex = {}
    for edge in edgesGot
      id = "#{nodesGot[edge.source].chembl_id} -(#{edge.enzyme})> #{nodesGot[edge.target].chembl_id}"
      edgesGotIndex[id] = edge

    for edgeMustBe in edgesMustBe

      sourceNodeMustBe = nodesMustBe[edgeMustBe.source]
      targetNodeMustBe = nodesMustBe[edgeMustBe.target]
      id = "#{sourceNodeMustBe.chembl_id} -(#{edgeMustBe.enzyme})> #{targetNodeMustBe.chembl_id}"

      edgeGot = edgesGotIndex[id]
      expect(edgeGot?).toBe(true)
      expect(edgeGot.enzyme).toBe(edgeMustBe.enzyme)
      expect(edgeGot.met_conversion).toBe(edgeMustBe.met_conversion)
      expect(edgeGot.organism).toBe(edgeMustBe.organism)
#      expect(edgeGot.doc_chembl_id).toBe(edgeMustBe.doc_chembl_id)
      expect(edgeGot.enzyme_chembl_id).toBe(edgeMustBe.enzyme_chembl_id)
      refsListMustBe = edgeMustBe.references_list.split("|").sort()
      refsListGot = edgeGot.references_list.split("|").sort()
      expect(TestsUtils.listsAreEqual(refsListMustBe, refsListGot)).toBe(true)

      sourceNodeGot = nodesGot[edgeGot.source]
      expect(sourceNodeMustBe.chembl_id).toBe(sourceNodeGot.chembl_id)

      targetNodeGot = nodesGot[edgeGot.target]
      expect(targetNodeMustBe.chembl_id).toBe(targetNodeGot.chembl_id)







