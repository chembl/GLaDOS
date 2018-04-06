describe 'Unichem Connectivity List', ->

  unichemConnectivityList = undefined

  beforeAll ->

    unichemConnectivityList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()

  it 'initialises from a Parent Compound', ->

    urlMustBe = "https://www.ebi.ac.uk/unichem/rest/key_search/BSYNRYMUTXBXSQ-UHFFFAOYSA-N/0/0/4?callback=xyz"
    console.log 'urlMustBe: ', urlMustBe
    console.log 'unichemConnectivityList: ', unichemConnectivityList

    #https://github.com/chembl/GLaDOS/blob/7d700baf02c129c27840bc6663e0b4f5dfd04163/src/glados/static/coffee/models/SearchModel.coffee#L31