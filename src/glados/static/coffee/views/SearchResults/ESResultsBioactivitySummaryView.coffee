# this view is in charge of showing the results as a compound vs Targets Matrix
glados.useNameSpace 'glados.views.SearchResults',
  ESResultsBioactivitySummaryView: Backbone.View.extend

    initialize: ->
      console.log 'ESResultsBioactivitySummaryView initialised!!'
      list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewBioactivitiesSummaryList()
      list.fetch()

      $columnsSelectorContainer = $(@el).find('.BCK-columns-selector-container')
      glados.Utils.fillContentForElement($columnsSelectorContainer)
      esIndexName = glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.ACTIVITY.PATH.replace('/','')
      console.log 'es index name: ', esIndexName
      activityColumns = Activity.COLUMNS
      console.log 'activityColumns: ', activityColumns


      $(@el).find('select').material_select()


