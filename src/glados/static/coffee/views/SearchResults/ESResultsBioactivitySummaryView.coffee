# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    initialize: ->
      console.log 'ESResultsBioactivitySummaryView initialised!!'
      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()
      list.fecth()


