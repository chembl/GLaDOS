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
    getNewESResultsListFor: (esIndexSettings, customQueryString='*', useCustomQueryString=false, itemsList,
      contextualProperties, searchTerm, stickyQuery) ->

      indexESPagQueryCollection = glados.models.paginatedCollections.ESPaginatedQueryCollection\
      .extend(glados.models.paginatedCollections.SelectionFunctions)
      .extend(glados.models.paginatedCollections.SortingFunctions)
      .extend(glados.models.paginatedCollections.ReferenceStructureFunctions)
      .extend(glados.models.paginatedCollections.CacheFunctions).extend
        model: esIndexSettings.MODEL

        initialize: ->

          @meta =
            index: esIndexSettings.PATH
            default_page_size: esIndexSettings.DEFAULT_PAGE_SIZE
            page_size: glados.Settings.CARD_PAGE_SIZES[2]
            available_page_sizes: glados.Settings.CARD_PAGE_SIZES
            current_page: 1
            to_show: []
            facets: esIndexSettings.FACETS
            id_column: esIndexSettings.ID_COLUMN
            facets_groups: esIndexSettings.FACETS_GROUPS
            columns: esIndexSettings.COLUMNS
            columns_description: esIndexSettings.COLUMNS_DESCRIPTION
            custom_default_card_sizes: esIndexSettings.CUSTOM_DEFAULT_CARD_SIZES
            custom_card_size_to_page_sizes: esIndexSettings.CUSTOM_CARD_SIZE_TO_PAGE_SIZES
            enable_cards_zoom: esIndexSettings.ENABLE_CARDS_ZOOM
            custom_cards_template: esIndexSettings.CUSTOM_CARDS_TEMPLATE
            custom_cards_item_view: esIndexSettings.CUSTOM_CARDS_ITEM_VIEW
            custom_card_item_view_details_columns: esIndexSettings.CUSTOM_CARD_ITEM_VIEW_DETAILS_COLUMNS
            complicate_cards_view: esIndexSettings.COMPLICATE_CARDS_VIEW
            complicate_card_columns: esIndexSettings.COMPLICATE_CARDS_COLUMNS
            download_formats: esIndexSettings.DOWNLOAD_FORMATS
            key_name: esIndexSettings.KEY_NAME
            id_name: esIndexSettings.ID_NAME
            label: esIndexSettings.LABEL
            available_views: esIndexSettings.AVAILABLE_VIEWS
            default_view: esIndexSettings.DEFAULT_VIEW
            all_items_selected: false
            selection_exceptions: {}
            custom_query_string: customQueryString
            use_custom_query_string: useCustomQueryString
            model: esIndexSettings.MODEL
            generator_items_list: itemsList
            contextual_properties: contextualProperties
            enable_similarity_maps: esIndexSettings.ENABLE_SIMILARITY_MAPS
            show_similarity_maps: esIndexSettings.SHOW_SIMILARITY_MAPS
            enable_substructure_highlighting: esIndexSettings.ENABLE_SUBSTRUCTURE_HIGHLIGHTING
            show_substructure_highlighting: esIndexSettings.SHOW_SUBSTRUCTURE_HIGHLIGHTING
            search_term: searchTerm
            sticky_query: stickyQuery
            data_loaded: false
            enable_collection_caching: esIndexSettings.ENABLE_COLLECTION_CACHING
            disable_cache_on_download: esIndexSettings.DISABLE_CACHE_ON_DOWNLOAD
            custom_possible_card_sizes_struct: esIndexSettings.POSSIBLE_CARD_SIZES_STRUCT

          if @getMeta('enable_similarity_maps') or @getMeta('enable_substructure_highlighting')
            @initReferenceStructureFunctions()

          if @getMeta('enable_collection_caching')
            @initCache()
            @on 'reset update', @addModelsInCurrentPage, @


      return new indexESPagQueryCollection

# creates a new instance of a Paginated Collection from Web Services
    getNewWSCollectionFor: (collectionSettings, filter='') ->
      wsPagCollection = glados.models.paginatedCollections.WSPaginatedCollection\
      .extend(glados.models.paginatedCollections.SelectionFunctions)
      .extend(glados.models.paginatedCollections.SortingFunctions)
      .extend(glados.models.paginatedCollections.CacheFunctions).extend

        model: collectionSettings.MODEL
        initialize: ->
          @meta =
            base_url: collectionSettings.BASE_URL
            default_page_size: collectionSettings.DEFAULT_PAGE_SIZE
            page_size: collectionSettings.DEFAULT_PAGE_SIZE
            available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            id_column: collectionSettings.ID_COLUMN
            columns: collectionSettings.COLUMNS
            columns_description: collectionSettings.COLUMNS_DESCRIPTION
            is_carousel: collectionSettings.IS_CAROUSEL
            all_items_selected: false
            selection_exceptions: {}
            custom_filter: filter
            data_loaded: false
            enable_collection_caching: collectionSettings.ENABLE_COLLECTION_CACHING

          @initialiseUrl()

          if @getMeta('enable_collection_caching')
            @initCache()
            @on 'reset', @addModelsInCurrentPage, @

      return new wsPagCollection

# creates a new instance of a Client Side Paginated Collection from either Web Services or elasticsearch, This means that
# the collection gets all the data is in one call and the full list is in the client all the time.
    getNewClientSideCollectionFor: (collectionSettings) ->

      collection = glados.models.paginatedCollections.ClientSidePaginatedCollection\
      .extend(glados.models.paginatedCollections.SelectionFunctions)
      .extend(glados.models.paginatedCollections.SortingFunctions).extend

        model: collectionSettings.MODEL

        initialize: ->
          @meta =
            base_url: collectionSettings.BASE_URL
            default_page_size: collectionSettings.DEFAULT_PAGE_SIZE
            page_size: collectionSettings.DEFAULT_PAGE_SIZE
            available_page_sizes: collectionSettings.AVAILABLE_PAGE_SIZES
            current_page: 1
            to_show: []
            id_column: collectionSettings.ID_COLUMN
            columns: collectionSettings.COLUMNS
            columns_description: collectionSettings.COLUMNS_DESCRIPTION
            all_items_selected: false
            selection_exceptions: {}
            data_loaded: false

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

    getNewESTargetsList: (customQueryString='*') ->
      list = @getNewESResultsListFor(glados.models.paginatedCollections.Settings.ES_INDEXES.TARGET,
        customQueryString, useCustomQueryString=true)
      return list

    getNewESCompoundsList: (customQueryString='*', itemsList, contextualProperties,
      settings=glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.COMPOUND_COOL_CARDS,
      searchTerm) ->


      list = @getNewESResultsListFor(settings, customQueryString, useCustomQueryString=(not itemsList?), itemsList,
        contextualProperties, searchTerm)
      return list

    getNewESActivitiesList: (customQueryString='*') ->
      list = @getNewESResultsListFor(glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.ACTIVITY,
        customQueryString, useCustomQueryString=true)
      return list

    getNewAssaysList: (filter='') ->

      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.ASSAYS_LIST, filter)
      list.parse = (data) ->
        data.page_meta.records_in_page = data.assays.length
        @setMeta('data_loaded', true)
        @resetMeta(data.page_meta)
        return data.assays

      return list

    getNewESDrugsList: (customQueryString='*', itemsList, contextualProperties,
      settings=glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH.DRUGS_LIST,
      searchTerm) ->

      stickyQuery =
        term:
          "_metadata.drug.is_drug": true

      list = @getNewESResultsListFor(settings, customQueryString, useCustomQueryString=(not itemsList?), itemsList,
        contextualProperties, searchTerm, stickyQuery)
      return list

    getNewActivitiesList: (filter='') ->

      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.ACTIVITIES_LIST, filter)
      list.parse = (data) ->
        data.page_meta.records_in_page = data.activities.length
        @setMeta('data_loaded', true)
        @resetMeta(data.page_meta)
        return data.activities

      return list

    getNewDrugList: ->
      list = @getNewWSCollectionFor(glados.models.paginatedCollections.Settings.WS_COLLECTIONS.DRUG_LIST)
      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @setMeta('data_loaded', true)
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
        @setMeta('data_loaded', true)
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
        @setMeta('data_loaded', true)
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
        @setMeta('data_loaded', true)
        @resetMeta(data.page_meta)

        return data.molecules

      return list

    getNewSimilaritySearchResultsListForCarousel: ->
      config = glados.models.paginatedCollections.Settings.WS_COLLECTIONS.COMPOUND_WS_RESULTS_LIST_CAROUSEL
      config.DEFAULT_PAGE_SIZE = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
      list = @getNewWSCollectionFor config

      list.initURL = (term, percentage) ->
        @baseUrl = glados.Settings.WS_BASE_SIMILARITY_SEARCH_URL + term + '/' + percentage + '.json'
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()


      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecules.length
        @setMeta('data_loaded', true)
        @resetMeta(data.page_meta)

        return data.molecules

      return list

#this list is to get the alternate forms of a compound
    getNewAlternateFormsListForCarousel: ->
      config = glados.models.paginatedCollections.Settings.WS_COLLECTIONS.COMPOUND_WS_RESULTS_LIST_CAROUSEL
      config.DEFAULT_PAGE_SIZE = glados.Settings.DEFAULT_CAROUSEL_SIZES[GlobalVariables.CURRENT_SCREEN_TYPE]
      list = @getNewWSCollectionFor config

      list.parse = (data) ->
        data.page_meta.records_in_page = data.molecule_forms.length
        @setMeta('data_loaded', true)
        @resetMeta(data.page_meta)

        return data.molecule_forms

      list.initURL = (chemblID) ->
        @baseUrl = glados.Settings.WS_BASE_URL + 'molecule_form/' + chemblID + '.json'
        console.log 'base url: ', @baseUrl
        @setMeta('base_url', @baseUrl, true)
        @initialiseUrl()

      return list

    getNewDocumentsFromTermsList: ->
      config = glados.models.paginatedCollections.Settings.WS_COLLECTIONS.DOCS_BY_TERM_LIST
      config.DEFAULT_PAGE_SIZE = 50
      list = @getNewWSCollectionFor(config)

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
            thisCollection.setMeta('data_loaded', true)
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
      list = @getNewClientSideCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST)

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

    getNewBioactivitiesSummaryList: ->
      list = @getNewClientSideCollectionFor(glados.models.paginatedCollections.Settings\
        .CLIENT_SIDE_ES_COLLECTIONS.BIOACTIVITY_SUMMARY_LIST)

      defaultComparators = ['target_chembl_id', 'target_organism', 'standard_type']
      list.setMeta('default_comparators', defaultComparators)
      list.setMeta('current_comparators', defaultComparators)

      list.url = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_activity/_search'

      list.getRequestData = ->

        aggregations = @getMeta('current_comparators')
        originChemblIDs = @getMeta('origin_chembl_ids')
        chemblIdsTexts = ('"' + id + '"' for id in originChemblIDs)

        requestData =
          query:
            query_string:
              analyze_wildcard: true,
              query: 'target_chembl_id:(' + chemblIdsTexts.join(' OR ')+ ')'
          size: 0

        placeToPutAgg = requestData
        for i in [0..aggregations.length-1]
          currentField = aggregations[i]
          aggName = currentField + '_agg'
          newAgg =
            terms:
              field: currentField
              size: 1000
              order:
                _count: 'desc'

          placeToPutAgg.aggs = {} unless placeToPutAgg.aggs?
          placeToPutAgg.aggs[aggName] = newAgg
          placeToPutAgg = placeToPutAgg.aggs[aggName]

        return requestData

      list.fetch = ->

        console.log 'FETCHING LIST!!'
        console.log 'request data: ', @getRequestData()
        esJSONRequest = JSON.stringify(@getRequestData())
        console.log 'esJSONRequest: ', esJSONRequest

        fetchESOptions =
          url: @url
          data: esJSONRequest
          type: 'POST'
          reset: true

        thisModel = @
        $.ajax(fetchESOptions).done((data) -> thisModel.set(thisModel.parse data))

      list.parse = (data) ->
        console.log 'parsing ', data

        # the data that ir receives form elastic is like a tree, this is like listing all leaves of the tree while
        # including data from their ancestry
        getInfoFromBuckets = (bucket, keyName) ->

          aggregations = _.filter(Object.keys(bucket), (key) -> key.search('_agg$') != -1)
          actsList = []

          if aggregations.length == 0
            # I am at the base case return a new activity. in a one item list to ease concatenating.
            act = new Activity
            act.set(Activity.COLUMNS.DOC_COUNT.comparator, bucket.doc_count)
            actsList = [act]
          else
            #recursive case, I need to check my children and add their answers to mine.

            for aggKey in aggregations
              currentAggData = bucket[aggKey]
              for currentBucket in currentAggData.buckets
                actsToAdd = getInfoFromBuckets(currentBucket, aggKey)
                actsList = actsList.concat(actsToAdd)

          # in either case, assign the value of the current aggregation field to every activity.
          currentPropertyName = if keyName.search('_agg$') != -1 then keyName.split('_agg')[0] else keyName
          currentPropertyValue = bucket.key

          for act in actsList
            act.set(currentPropertyName, currentPropertyValue)

          return actsList

        models = []
        rootBucket = {key: true}
        for aggKey, value of data.aggregations
          rootBucket[aggKey] = value

        models = getInfoFromBuckets(rootBucket, Activity.COLUMNS.IS_AGGREGATION.comparator)
        @setMetadataAfterParse()
        @setMeta('data_loaded', true)
        @reset(models)

      console.log 'CREATING NEW BIOACTIVITIES SUMMARY LIST!'
      console.log 'list: ', list

      list.setMetadataAfterParse = ->

        currentComparators = @getMeta('current_comparators')
        console.log 'currentComparators: ', currentComparators
        columnsIndex = _.indexBy(Activity.COLUMNS, 'comparator')
        columnsToShow = []
        for comp in currentComparators
          currentColumn = columnsIndex[comp]
          currentColumn.show = true
          columnsToShow.push currentColumn
        # also add count!
        countColumn = Activity.COLUMNS.DOC_COUNT
        countColumn.show = true
        columnsToShow.push countColumn
        list.setMeta('columns', columnsToShow)
        @resetMeta()

      # ----------------------------------------------------------------------------------
      # -- End of custom functions for bioactivity summary list
      # ----------------------------------------------------------------------------------

      return list


    getNewTargetRelationsList: ->
      list = @getNewClientSideCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_RELATIONS_LIST)
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

        base_url2 = glados.Settings.WS_BASE_URL + 'target.json?target_chembl_id__in='

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
      list = @getNewClientSideCollectionFor(glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_COMPONENTS_LIST)

      list.initURL = (chembl_id) ->
        @url = glados.Settings.WS_BASE_URL + 'target/' + chembl_id + '.json'

      list.parse = (response) ->
        @setMeta('data_loaded', true)
        return response.target_components


      return list



