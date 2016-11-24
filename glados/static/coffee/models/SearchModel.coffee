# This model defines the simple and advanced search fields,
# and it is in charge of coordinating the query among the other models
SearchModel = Backbone.Model.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

  defaults:
    queryString: ''
    searchCompounds: true
    searchDocuments: true
    compoundResultsList: null
    documentResultsList: null

  # --------------------------------------------------------------------------------------------------------------------
  # Models
  # --------------------------------------------------------------------------------------------------------------------

  # Lazily initialized CompoundResultsList
  getCompoundResultsList: () ->
    if not @has('compoundResultsList')
      @set('compoundResultsList',
          glados.models.paginated_collections.PaginatedCollectionFactory.getNewCompoundResultsList())
    return @get('compoundResultsList')

  # Lazily initialized DocumentResultsList
  getDocumentResultsList: () ->
    if not @has('documentResultsList')
      @set('documentResultsList',
          glados.models.paginated_collections.PaginatedCollectionFactory.getNewDocumentResultsList())
    return @get('documentResultsList')

  # --------------------------------------------------------------------------------------------------------------------
  # Functions
  # --------------------------------------------------------------------------------------------------------------------

  # coordinates the search across the different
  search: () ->
    if @get('searchCompounds')
      @getCompoundResultsList().setMeta('search_term',@get('queryString'))
      @getCompoundResultsList().fetch()
    if @get('searchDocuments')
      @getDocumentResultsList().setMeta('search_term',@get('queryString'))
      @getDocumentResultsList().fetch()

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance
