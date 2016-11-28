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
            base_url: collectionSettings.BASE_URL
            page_size: collectionSettings.DEFAULT_PAGE_SIZE
            available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            columns: collectionSettings.COLUMNS

          @initialiseUrl()


      return new wsPagCollection

    # ------------------------------------------------------------------------------------------------------------------
    # Specific instantiation of paginated collections
    # ------------------------------------------------------------------------------------------------------------------

    getNewCompoundResultsList: () ->
      return @getNewESResultsListFor(glados.models.paginated_collections.Settings.ES_INDEXES.COMPOUND)

    getNewDocumentResultsList: () ->
      return @getNewESResultsListFor(glados.models.paginated_collections.Settings.ES_INDEXES.DOCUMENT)

    getNewDrugList: ->
      list =  @getNewWSCollectionFor(glados.models.paginated_collections.Settings.WS_COLLECTIONS.DRUG_LIST)
      list.parse = (data) ->

          data.page_meta.records_in_page = data.molecules.length
          @resetMeta(data.page_meta)

          return data.molecules

      return list

    getNewDocumentsFromTermsList: ->

      list =  @getNewWSCollectionFor(glados.models.paginated_collections.Settings.WS_COLLECTIONS.DOCS_BY_TERM_LIST)

      list.initUrl = (term) ->

        @baseUrl = Settings.WS_BASE_URL + 'document_term.json?term_text=' + term + '&order_by=-score'
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()

      list.fetch = ->

        @reset()
        url = @getPaginatedURL()
        documents = []
        totalDocs = 0
        receivedDocs = 0
        # 1 first get list of documents
        getDocuments = $.getJSON(url)

        thisCollection = @
        # 3. check that everything is ready
        checkAllInfoReady = ->
          if receivedDocs == totalDocs
            console.log 'ALL READY!'
            console.log thisCollection
            thisCollection.trigger('do-repaint')

        getDocuments.done( (data) ->

          data.page_meta.records_in_page = data.document_terms.length
          thisCollection.resetMeta(data.page_meta)

          documents = data.document_terms
          totalDocs = documents.length

          # 2. get details per document
          for docInfo in documents

            doc = new Document(docInfo)
            thisCollection.add doc
            doc.fetch
              success: ->
                receivedDocs += 1
                checkAllInfoReady()

        )

        getDocuments.fail ->

          console.log 'ERROR!'

      return list
