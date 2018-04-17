describe 'Blog Entries List', ->

  list = undefined

  beforeAll (done) ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBlogEntriesList()

    done()
  it 'generates initial url', ->


    urlMustBe = "#{glados.Settings.GLADOS_BASE_PATH_REL}blog_entries"
    urlGot = list.initURL()

    expect(urlGot).toBe(urlMustBe)

