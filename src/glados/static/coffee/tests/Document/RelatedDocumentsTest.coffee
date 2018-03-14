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
    console.log 'document: ', document

    relatedDocumentsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewRelatedDocumentsList()
    console.log 'relatedDocumentsList: ', relatedDocumentsList
    rawSimilarDocs = document.get('_metadata').similar_documents
    console.log 'rawSimilarDocs: ', rawSimilarDocs