describe 'Related Documents List', ->

  chemblID = 'CHEMBL1614631'
  document = new Document
    document_chembl_id: chemblID
    fetch_from_elastic: true

  esResponse = undefined
  parsed = undefined

  beforeAll (done) ->

    dataURL = glados.Settings.STATIC_URL + 'testData/Documents/CHEMBL1122698WithSimilarDocumentsESResponse.json'
    $.get dataURL, (testData) ->
      esResponse = testData
      parsed = document.parse(esResponse)
      done()

  it 'initialises from a Document', ->

    document.set(parsed)

    relatedDocumentsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewRelatedDocumentsList()
    rawSimilarDocs = document.get('_metadata').similar_documents
    relatedDocumentsList.reset(_.map(rawSimilarDocs, Document.prototype.parse))

    for doc in rawSimilarDocs
      parsedDoc = relatedDocumentsList.get(doc.document_chembl_id)
      expect(parsedDoc.get('id')).toBe(doc.document_chembl_id)
      expect(parsedDoc.get('tid_tani')).toBe(doc.tid_tani)
      expect(parsedDoc.get('mol_tani')).toBe(doc.mol_tani)