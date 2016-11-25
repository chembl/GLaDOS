glados.useNameSpace 'glados.models.paginated_collections'
  # --------------------------------------------------------------------------------------------------------------------
  # Factory for Elastic Search Generic Paginated Results List Collection
  # Creates a paginated collection based on:
  # - MODEL: which backbone model will parse the json data that comes from elastic search
  # - PATH: the index path in the elastic search server
  # - COLUMNS: a columns description  used for ordering and the views
  # --------------------------------------------------------------------------------------------------------------------
  PaginatedCollectionFactory:

    # creates a new instance of a Paginated Collection from Elastic Search
    getNewESResultsListFor : (esIndexSettings) ->
      indexESPagQueryCollection = glados.models.paginated_collections.ESPaginatedQueryCollection.extend
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

    # creates a new instance of a Paginated Collection from Web Services
    getNewWSCollectionFor: (collectionSettings) ->

      wsPagCollection = glados.models.paginated_collections.WSPaginatedCollection.extend
        model: collectionSettings.MODEL
        initialize: ->

          @meta =
            base_url: Settings.WS_BASE_URL + 'molecule.json'
            page_size: Settings.TABLE_PAGE_SIZES[2]
            available_page_sizes: Settings.TABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            columns: collectionSettings.COLUMNS

          @initialiseUrl()

        parse: (data) ->

          data.page_meta.records_in_page = data.molecules.length
          @resetMeta(data.page_meta)

          return data.molecules

      return new wsPagCollection






    # ------------------------------------------------------------------------------------------------------------------
    # Specific instantiation of paginated collections
    # ------------------------------------------------------------------------------------------------------------------

    getNewCompoundResultsList: () ->
      return @getNewESResultsListFor(glados.models.paginated_collections.Settings.ES_INDEXES.COMPOUND)

    getNewDocumentResultsList: () ->
      return @getNewESResultsListFor(glados.models.paginated_collections.Settings.ES_INDEXES.DOCUMENT)

    getNewDrugList: ->
      return @getNewWSCollectionFor(glados.models.paginated_collections.Settings.WS_COLLECTIONS.DRUG_LIST)
