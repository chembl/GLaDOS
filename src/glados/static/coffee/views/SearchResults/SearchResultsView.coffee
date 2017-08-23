glados.useNameSpace 'glados.views.SearchResults',
  SearchResultsView: Backbone.View.extend
    initialize: ->

      @searchResultsMenusViewsDict = {}
      @$searchResultsListsContainersDict = {}

      $listsContainer = $(@el).find('.BCK-ESResults-lists')
      console.log '$listsContainer: ', $listsContainer
      # @searchModel.getResultsListsDict() and glados.models.paginatedCollections.Settings.ES_INDEXES
      # Share the same keys to access different objects
      resultsListsDict = @model.getResultsListsDict()

      $listsContainer.empty()
      for resourceName, resultsListSettings of glados.models.paginatedCollections.Settings.ES_INDEXES

        if resultsListsDict[resourceName]?
          resultsListViewID = @getBCKListContainerBaseID(resourceName)
          $container = $('<div id="' + resultsListViewID + '-container">')
          glados.Utils.fillContentForElement($container, {entity_name: @getEntityName(resourceName)},
            'Handlebars-ESResultsList')
          $listsContainer.append($container)

          # Initialises a Menu view which will be in charge of handling the menu bar,
          # Remember that this is the one that creates, shows and hides the Results lists views! (Matrix, Table, Graph, etc)
          resultsMenuViewI = new glados.views.Browsers.BrowserMenuView
            collection: resultsListsDict[resourceName]
            el: $container.find('.BCK-BrowserContainer')

          resultsMenuViewI.render()
          @searchResultsMenusViewsDict[resourceName] = resultsMenuViewI
          @$searchResultsListsContainersDict[resourceName] = $('#'+resultsListViewID + '-container')


    getBCKListContainerBaseID: (resourceName) ->
      return 'BCK-'+glados.models.paginatedCollections.Settings.ES_INDEXES[resourceName].ID_NAME

    getEntityName: (resourceName) -> resourceName.replace(/_/g, ' ').toLowerCase() + 's'
