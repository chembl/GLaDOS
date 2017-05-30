glados.useNameSpace 'glados.models.paginatedCollections',
# --------------------------------------------------------------------------------------------------------------------
# Factory for Elastic Search Generic Paginated Results List Collection
# Creates a paginated collection based on:
# - MODEL: which backbone model will parse the json data that comes from elastic search
# - PATH: the index path in the elastic search server
# - COLUMNS: a columns description  used for ordering and the views
# --------------------------------------------------------------------------------------------------------------------
  PaginatedCollectionFactory:
# creates a new instance of a Paginated Collection from Elastic Search
    getNewESResultsListFor: (esIndexSettings) ->
      indexESPagQueryCollection = glados.models.paginatedCollections.ESPaginatedQueryCollection\
      .extend(glados.models.paginatedCollections.SelectionFunctions).extend
        model: esIndexSettings.MODEL

        initialize: ->

          @meta =
            index: esIndexSettings.PATH
            page_size: glados.Settings.CARD_PAGE_SIZES[2]
            available_page_sizes: glados.Settings.CARD_PAGE_SIZES
            current_page: 1
            to_show: []
            facets: esIndexSettings.FACETS
            id_column: esIndexSettings.ID_COLUMN
            facets_groups: esIndexSettings.FACETS_GROUPS
            # set by default columns with show: true, and additional with show: false
            columns: ( $.extend(col, {show: true})  for col in esIndexSettings.COLUMNS)
            #columns specific for cards view
            columns_card: ( $.extend(col, {show: true})  for col in esIndexSettings.COLUMNS_CARD)
            additional_columns: ( $.extend(col, {show: false}) for col in esIndexSettings.ADDITIONAL_COLUMNS)
            download_formats: esIndexSettings.DOWNLOAD_FORMATS
            key_name: esIndexSettings.KEY_NAME
            id_name: esIndexSettings.ID_NAME
            available_views: esIndexSettings.AVAILABLE_VIEWS
            default_view: esIndexSettings.DEFAULT_VIEW
            all_items_selected: false
            selection_exceptions: {}

      return new indexESPagQueryCollection

# creates a new instance of a Paginated Collection from Web Services
    getNewWSCollectionFor: (collectionSettings, filter='') ->
      wsPagCollection = glados.models.paginatedCollections.WSPaginatedCollection\
      .extend(glados.models.paginatedCollections.SelectionFunctions).extend

        model: collectionSettings.MODEL
        initialize: ->
          @meta =
            base_url: collectionSettings.BASE_URL
            page_size: collectionSettings.DEFAULT_PAGE_SIZE
            available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            id_column: collectionSettings.ID_COLUMN
            columns: ( $.extend(col, {show: true})  for col in collectionSettings.COLUMNS)
            #columns specific for cards view
            columns_card: ( $.extend(col, {show: true})  for col in collectionSettings.COLUMNS_CARD)
            additional_columns: ( $.extend(col, {show: false}) for col in collectionSettings.ADDITIONAL_COLUMNS)
            is_carousel: collectionSettings.IS_CAROUSEL
            all_items_selected: false
            selection_exceptions: {}
            custom_filter: filter

          @initialiseUrl()

      return new wsPagCollection

# creates a new instance of a Client Side Paginated Collection from Web Services, This means that
# the collection gets all the data is in one call and the full list is in the client all the time.
    getNewClientSideWSCollectionFor: (collectionSettings) ->
      collection = glados.models.paginatedCollections.ClientSideWSPaginatedCollection\
      .extend(glados.models.paginatedCollections.SelectionFunctions).extend

        model: collectionSettings.MODEL

        initialize: ->
          @meta =
            base_url: collectionSettings.BASE_URL
            page_size: collectionSettings.DEFAULT_PAGE_SIZE
            available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            id_column: collectionSettings.ID_COLUMN
            columns: ( $.extend(col, {show: true})  for col in collectionSettings.COLUMNS)
            additional_columns: ( $.extend(col, {show: false}) for col in collectionSettings.ADDITIONAL_COLUMNS)
            all_items_selected: false
            selection_exceptions: {}

          @on 'reset', @resetMeta, @

      return new collection


# ------------------------------------------------------------------------------------------------------------------
# Specific instantiation of paginated collections
# ------------------------------------------------------------------------------------------------------------------

    getAllESResultsListDict: () ->
      res_lists_dict = {}
      for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
        res_lists_dict[key_i] = @getNewESResultsListFor(val_i)
      return res_lists_dict

    getNewAssaysList: (filter='') ->

      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.ACTIVITIES_LIST, filter)

      return list

    getNewActivitiesList: (filter='') ->

      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.ACTIVITIES_LIST, filter)
      list.parse = (data) ->
        data.page_meta.records_in_page = data.activities.length
        @resetMeta(data.page_meta)
        return data.activities

      return list

    getNewDrugList: ->
      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.DRUG_LIST)
      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @resetMeta(data.page_meta)

        return data.molecules

      return list

    getNewSubstructureSearchResultsList: ->
      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.SUBSTRUCTURE_RESULTS_LIST)

      list.initURL = (term) ->
        @baseUrl = glados.Settings.WS_BASE_SUBSTRUCTURE_SEARCH_URL + term + '.json'
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()


      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @resetMeta(data.page_meta)

        return data.molecules

      return list

    getNewFlexmatchSearchResultsList: ->

# this list has the same columns as the one used for substrucure
      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.SUBSTRUCTURE_RESULTS_LIST)

      list.initURL = (term) ->
        @baseUrl = glados.Settings.WS_BASE_FLEXMATCH_SEARCH_URL + term
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()


      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @resetMeta(data.page_meta)

        return data.molecules

      return list

    getNewSimilaritySearchResultsList: ->
      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.SIMILARITY_RESULTS_LIST)

      list.initURL = (term, percentage) ->
        @baseUrl = glados.Settings.WS_BASE_SIMILARITY_SEARCH_URL + term + '/' + percentage + '.json'
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()


      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @resetMeta(data.page_meta)

        return data.molecules

      return list

    getNewSimilaritySearchResultsListForCarousel: ->
      config = glados.models.paginatedCollections.Settings.WS_COLLECTIONS.COMPOUND_WS_RESULTS_LIST_CAROUSEL
      config.DEFAULT_PAGE_SIZE = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
      list = @getNewWSCollectionFor config

      list.responsivisePageSize()

      list.initURL = (term, percentage) ->
        @baseUrl = glados.Settings.WS_BASE_SIMILARITY_SEARCH_URL + term + '/' + percentage + '.json'
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()


      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @resetMeta(data.page_meta)

        return data.molecules

      return list

#this list is to get the alternate forms of a compound
    getNewAlternateFormsListForCarousel: ->
      config = glados.models.paginatedCollections.Settings.WS_COLLECTIONS.COMPOUND_WS_RESULTS_LIST_CAROUSEL
      config.DEFAULT_PAGE_SIZE = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
      list = @getNewWSCollectionFor config
      list.responsivisePageSize()

      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecule_forms.length
        @resetMeta(data.page_meta)

        return data.molecule_forms

      list.initURL = (chemblID) ->
        @baseUrl = glados.Settings.WS_BASE_URL + 'molecule_form/' + chemblID + '.json'
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()

      return list

    getNewDocumentsFromTermsList: ->
      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.DOCS_BY_TERM_LIST)

      list.initURL = (term) ->
        @baseUrl = glados.Settings.WS_BASE_URL + 'document_term.json?term_text=' + term + '&order_by=-score'
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

        getDocuments.done((data) ->
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

    getNewApprovedDrugsClinicalCandidatesList: ->
      list = @getNewClientSideWSCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST)

      list.initURL = (chembl_id) ->
        @url = glados.Settings.WS_BASE_URL + 'mechanism.json?target_chembl_id=' + chembl_id

      list.fetch = ->
        this_collection = @
        drug_mechanisms = {}

        # 1 first get list of drug mechanisms
        getDrugMechanisms = $.getJSON(@url, (data) ->
          drug_mechanisms = data.mechanisms
        )

        getDrugMechanisms.fail(()->
          console.log('error')
          this_collection.trigger('error')
        )

        base_url2 = glados.Settings.WS_BASE_URL + 'molecule.json?molecule_chembl_id__in='
        # after I have the drug mechanisms now I get the molecules
        getDrugMechanisms.done(() ->
          molecules_list = (dm.molecule_chembl_id for dm in drug_mechanisms).join(',')
          # order is very important to iterate in the same order as the first call
          getMoleculesInfoUrl = base_url2 + molecules_list + '&order_by=molecule_chembl_id&limit=1000'

          getMoleculesInfo = $.getJSON(getMoleculesInfoUrl, (data) ->
            molecules = data.molecules
            # Now I fill the missing information, both arrays are ordered by molecule_chembl_id
            i = 0
            for mol in molecules

              drug_mechanisms[i].max_phase = mol.max_phase
              drug_mechanisms[i].pref_name = mol.pref_name

              i++

            # here everything is ready
            this_collection.reset(drug_mechanisms)
          )

          getMoleculesInfo.fail(()->
            console.log('failed2')
          )
        )

      return list

    getNewTargetRelationsList: ->
      list = @getNewClientSideWSCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_RELATIONS_LIST)
      list.initURL = (chembl_id) ->
        @url = glados.Settings.WS_BASE_URL + 'target_relation.json?related_target_chembl_id=' + chembl_id + '&order_by=target_chembl_id&limit=1000'

      list.fetch = ->
        this_collection = @
        target_relations = {}

        # 1 first get list of target relations
        getTargetRelations = $.getJSON(@url, (data) ->
          target_relations = data.target_relations
        )

        getTargetRelations.fail(()->
          console.log('error')
          this_collection.trigger('error')
        )

        base_url2 = glados.Settings.WS_DEV_BASE_URL + 'target.json?target_chembl_id__in='

        # after I have the target relations now I get the actual targets
        getTargetRelations.done(() ->
          targets_list = (t.target_chembl_id for t in target_relations).join(',')
          # order is very important to iterate in the same order as the first call
          getTargetssInfoUrl = base_url2 + targets_list + '&order_by=target_chembl_id&limit=1000'

          getTargetsInfo = $.getJSON(getTargetssInfoUrl, (data) ->
            targets = data.targets
            # Now I fill the missing information, both arrays are ordered by target_chembl_id
            i = 0
            for targ in targets

# TODO:
# this is because the dev server is returning less values, this needs to be checked
              if targ.target_chembl_id != target_relations[i].target_chembl_id
                i++;

              target_relations[i].pref_name = targ.pref_name
              target_relations[i].target_type = targ.target_type

              i++

            # here everything is ready
            this_collection.reset(target_relations)
          )

          getTargetsInfo.fail(()->
            console.log('failed2')
          )
        )

      return list

    getNewTargetComponentsList: ->
      list = @getNewClientSideWSCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_COMPONENTS_LIST)

      list.initURL = (chembl_id) ->
        @url = glados.Settings.WS_BASE_URL + 'target/' + chembl_id + '.json'

      list.parse = (response) ->
        return response.target_components


      return list



