glados.useNameSpace 'glados.models.paginatedCollections',

  PaginatedCollectionBase: Backbone.Collection.extend

    initialize: ->

      @setInitialFetchingState()
      @setInitialSearchState()
      if @islinkToOtherEntitiesEnabled()
        @on glados.Events.Collections.SELECTION_UPDATED, @resetLinkToOtherEntitiesCache, @

        @on glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_FETCHING_STATE_CHANGED,
        @resetLinkToOtherEntitiesCache, @

    islinkToOtherEntitiesEnabled: ->

      linksToOtherEntities = @getMeta('links_to_other_entities')
      if not linksToOtherEntities?
        return false
      if linksToOtherEntities.length == 0
        return false

      return true

    getTotalRecords: ->
      totalRecords = @getMeta('total_records')
      totalRecords ?= 0
      return totalRecords

    getLinkToListFunction: -> @getMeta('browse_list_url')
    # ------------------------------------------------------------------------------------------------------------------
    # Downloads
    # ------------------------------------------------------------------------------------------------------------------
    downloadIsValidAndReady: ->

      if not @allResults?
        return false

      if not @DOWNLOADED_ITEMS_ARE_VALID
        return false

      for result in @allResults
        if not result?
          return false

      return true

    # ------------------------------------------------------------------------------------------------------------------
    # Utils
    # ------------------------------------------------------------------------------------------------------------------
    getModelEntityName: -> @getMeta('model').prototype.entityName
    getIDProperty: -> @getMeta('id_column').comparator
    # ------------------------------------------------------------------------------------------------------------------
    # Link to all activities and other entities
    # ------------------------------------------------------------------------------------------------------------------
    LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES:
      "#{Activity.prototype.entityName}": 'all_activities_link_cache'
      "#{Compound.prototype.entityName}": 'all_compounds_link_cache'
      "#{Target.prototype.entityName}": 'all_targets_link_cache'
      "#{Document.prototype.entityName}": 'all_documents_link_cache'
      "#{Assay.prototype.entityName}": 'all_assays_link_cache'
      "#{CellLine.prototype.entityName}": 'all_cell_lines_link_cache'
      "#{glados.models.Tissue.prototype.entityName}": 'all_tissues_link_cache'


    thereAreTooManyItemsForActivitiesLink: ->

      numSelectedItems = @getNumberOfSelectedItems()
      numItemsForLink = if numSelectedItems == 0 then @getTotalRecords() else numSelectedItems
      if numItemsForLink >= glados.Settings.VIEW_SELECTION_THRESHOLDS.Heatmap[1]
        return true
      return false

    resetLinkToOtherEntitiesCache: ->

      for entityName, propName of @LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES
        @setMeta(propName, undefined)

    getLinkToRelatedEntities: (itemsList, destinationEntityName) ->

      sourceEntityName = @getModelEntityName()
      filter = @ENTITY_NAME_TO_FILTER_GENERATOR[sourceEntityName][destinationEntityName]
        ids: itemsList

      if destinationEntityName == Activity.prototype.entityName
        return Activity.getActivitiesListURL(filter)
      else if destinationEntityName == Compound.prototype.entityName
        return Compound.getCompoundsListURL(filter)
      else if destinationEntityName == Target.prototype.entityName
        return Target.getTargetsListURL(filter)
      else if destinationEntityName == Document.prototype.entityName
        return Document.getDocumentsListURL(filter)
      else if destinationEntityName == Assay.prototype.entityName
        return Assay.getAssaysListURL(filter)
      else if destinationEntityName == CellLine.prototype.entityName
        return CellLine.getCellsListURL(filter)
      else if destinationEntityName == glados.models.Tissue.prototype.entityName
        return glados.models.Tissue.getTissuesListURL(filter)

    getLinkToRelatedEntitiesPromise: (destinationEntityName) ->

      cachePropName = @LINKS_TO_RELATED_ENTITIES_CACHE_PROP_NAMES[destinationEntityName]
      cache = @getMeta(cachePropName)

      if cache?
        return jQuery.Deferred().resolve(cache)

      linkPromise = jQuery.Deferred()

      propertyToPluck = undefined
      sourceEntityName = @getModelEntityName()
      if sourceEntityName == Activity.prototype.entityName
        propertyToPluck = glados.Settings.ENTITY_NAME_TO_ENTITY[destinationEntityName].prototype.idAttribute

      # if all items are un selected the link must be done with all of them.
      iDsPromise = @getItemsIDsPromise(onlySelected=(not @allItemsAreUnselected()), propertyToPluck)

      thisCollection = @
      iDsPromise.then (selectedIDs) ->

        link = thisCollection.getLinkToRelatedEntities(selectedIDs, destinationEntityName)
        thisCollection.setMeta(cachePropName, link)
        linkPromise.resolve(link)

      return linkPromise

    # This gives a filter from a source entity to a destination entity. For example if you want from the compounds
    # to get the related activities you need ['Compound']['Activity']
    ENTITY_NAME_TO_FILTER_GENERATOR:
      "#{Compound.prototype.entityName}":
        "#{Activity.prototype.entityName}":\
          Handlebars.compile('molecule_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Target.prototype.entityName}":
        "#{Activity.prototype.entityName}":\
          Handlebars.compile('target_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Document.prototype.entityName}":
        "#{Activity.prototype.entityName}":\
          Handlebars.compile('document_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Assay.prototype.entityName}":
        "#{Activity.prototype.entityName}":\
          Handlebars.compile('assay_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{CellLine.prototype.entityName}":
        "#{Activity.prototype.entityName}":\
          Handlebars.compile('_metadata.assay_data.cell_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{glados.models.Tissue.prototype.entityName}":
        "#{Activity.prototype.entityName}":\
          Handlebars.compile('_metadata.assay_data.tissue_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{glados.models.Compound.Drug}":
        "#{Activity.prototype.entityName}":
          Handlebars.compile('molecule_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
      "#{Activity.prototype.entityName}":
        "#{Compound.prototype.entityName}":
          Handlebars.compile('molecule_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
        "#{Target.prototype.entityName}":
          Handlebars.compile('target_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
        "#{Assay.prototype.entityName}":
          Handlebars.compile('assay_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')
        "#{Document.prototype.entityName}":
          Handlebars.compile('document_chembl_id:({{#each ids}}"{{this}}"{{#unless @last}} OR {{/unless}}{{/each}})')

    # ------------------------------------------------------------------------------------------------------------------
    # Fetching state handling
    # ------------------------------------------------------------------------------------------------------------------
    getItemsFetchingState: -> @getMeta('items_fetching_state')
    getFacetsFetchingState: -> @getMeta('facets_fetching_state')
    setItemsFetchingState: (newFetchingState) ->
      @setMeta('items_fetching_state', newFetchingState)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.ITEMS_FETCHING_STATE_CHANGED)
    setFacetsFetchingState: (newFetchingState) ->
      @setMeta('facets_fetching_state', newFetchingState)
      @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.FACETS_FETCHING_STATE_CHANGED)
    setInitialFetchingState: ->
      @setMeta('items_fetching_state',
        glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.INITIAL_STATE)
      @setMeta('facets_fetching_state',
        glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.INITIAL_STATE)

    itemsAreReady: ->

      itemsAreReady = @getMeta('items_fetching_state') == \
      glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.ITEMS_READY
      return itemsAreReady

    facetsAreReady: ->

      facetsAreReady = @getMeta('facets_fetching_state') == \
      glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.FACETS_READY
      return facetsAreReady

    isReady: -> @itemsAreReady() and @facetsAreReady()

    facetsAreInInitalState: -> @getMeta('facets_fetching_state') == \
      glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES.INITIAL_STATE

    itemsAreInInitalState: -> @getMeta('items_fetching_state') == \
      glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES.INITIAL_STATE

    # ------------------------------------------------------------------------------------------------------------------
    # Searching state handling
    # ------------------------------------------------------------------------------------------------------------------
    getSearchState: -> @getMeta('search_state')
    setInitialSearchState: -> @setMeta('search_state',
      glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_UNDEFINED)
    setSearchState: (newState) ->
      oldState = @getSearchState()
      if oldState != newState
        @setMeta('search_state', newState)
        @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.SEARCH_STATE_CHANGED)
    searchQueryIsSet: -> @getSearchState() ==\
      glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_QUERY_SET
    searchIsReady: -> @getMeta('search_state') ==\
      glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES.SEARCH_IS_READY

    # ------------------------------------------------------------------------------------------------------------------ 
    # Sleep/Awake states
    # ------------------------------------------------------------------------------------------------------------------
    getAwakenState: -> @getMeta('awaken_state')
    isSleeping: -> @getMeta('awaken_state') ==\
      glados.models.paginatedCollections.PaginatedCollectionBase.AWAKEN_STATES.SLEEPING
    isAwaken: -> @getMeta('awaken_state') ==\
      glados.models.paginatedCollections.PaginatedCollectionBase.AWAKEN_STATES.AWAKEN

    setAwakenState: (newState, silent=false) ->
      oldState = @getAwakenState()
      if oldState != newState
        @setMeta('awaken_state', newState)
        @trigger(glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.AWAKE_STATE_CHANGED) unless silent
    wakeUp: (silent=false) ->
      @setAwakenState(glados.models.paginatedCollections.PaginatedCollectionBase.AWAKEN_STATES.AWAKEN, silent)
    sleep: ->
      @setAwakenState(glados.models.paginatedCollections.PaginatedCollectionBase.AWAKEN_STATES.SLEEPING)

    awakenStateIsUnknown: -> not @getAwakenState()?

    doFetchWhenAwaken: ->

      if @isAwaken()
        @fetch()
        return

      fetchIfAwaken = ->

        if @isAwaken()
          @off glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.AWAKE_STATE_CHANGED, fetchIfAwaken, @
          @fetch()

      @once glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS.AWAKE_STATE_CHANGED, fetchIfAwaken, @



glados.models.paginatedCollections.PaginatedCollectionBase.EVENTS =
  ITEMS_FETCHING_STATE_CHANGED: 'ITEMS_FETCHING_STATE_CHANGED'
  FACETS_FETCHING_STATE_CHANGED: 'FACETS_FETCHING_STATE_CHANGED'
  SEARCH_STATE_CHANGED: 'SEARCH_STATE_CHANGED'
  AWAKE_STATE_CHANGED: 'AWAKE_STATE_CHANGED'
  STATE_OBJECT_CHANGED: 'STATE_OBJECT_CHANGED'

glados.models.paginatedCollections.PaginatedCollectionBase.ITEMS_FETCHING_STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  FETCHING_ITEMS: 'FETCHING_ITEMS'
  ITEMS_READY: 'ITEMS_READY'

glados.models.paginatedCollections.PaginatedCollectionBase.FACETS_FETCHING_STATES =
  INITIAL_STATE: 'INITIAL_STATE'
  FETCHING_FACETS: 'FETCHING_FACETS'
  FACETS_READY: 'FACETS_READY'

glados.models.paginatedCollections.PaginatedCollectionBase.SEARCHING_STATES =
  SEARCH_UNDEFINED: 'SEARCH_UNDEFINED'
  SEARCH_QUERY_SET: 'SEARCH_QUERY_SET' #this means that the esQuery is set and it is ready to be fetched, but fetching
  # has not been done
  SEARCH_IS_READY: 'SEARCH_IS_READY' # the fetch has been done, and the data has been received and parsed.

glados.models.paginatedCollections.PaginatedCollectionBase.AWAKEN_STATES =
  SLEEPING: 'SLEEPING'
  AWAKEN: 'AWAKEN'