glados.useNameSpace 'glados.models.elastic_search'
  # --------------------------------------------------------------------------------------------------------------------
  # Factory for Elastic Search Generic Paginated Results List Collection
  # Creates a paginated collection based on:
  # - MODEL: which backbone model will parse the json data that comes from elastic search
  # - PATH: the index path in the elastic search server
  # - COLUMNS: a columns description  used for ordering and the views
  # --------------------------------------------------------------------------------------------------------------------
  ESPaginatedQueryCollectionFactory:

    # creates a new instance of a Paginated Collection from Elastic Search
    getNewESResultsListFor : (esIndexSettings) ->
      indexESPagQueryCollection = glados.models.elastic_search.ESPaginatedQueryCollection.extend
        model: esIndexSettings.MODEL

        initialize: ->

          @meta =
            index: esIndexSettings.PATH
            page_size: Settings.CARD_PAGE_SIZES[0]
            available_page_sizes: Settings.CARD_PAGE_SIZES
            current_page: 1
            to_show: []
            columns: esIndexSettings.COLUMNS
      return new indexESPagQueryCollection

    # ------------------------------------------------------------------------------------------------------------------
    # Specific instantiation of paginated collections
    # ------------------------------------------------------------------------------------------------------------------

    getNewCompoundResultsList: () ->
      return @getNewESResultsListFor(glados.models.elastic_search.Settings.ES_INDEXES.COMPOUND)

    getNewDocumentResultsList: () ->
      return @getNewESResultsListFor(glados.models.elastic_search.Settings.ES_INDEXES.DOCUMENT)
