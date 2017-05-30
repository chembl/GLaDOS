class AssaysBrowserApp

  @init = ->

    list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAssaysList()
    console.log 'init assay browser app!'
    console.log 'list: ', list