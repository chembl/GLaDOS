# This model defines the simple and advanced search fields,
# and it is in charge of coordinating the query among the other models
SearchModel = Backbone.Model.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

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
    if not @compoundResultsList
      @compoundResultsList = new CompoundResultsList
    return @compoundResultsList

  # Lazily initialized DocumentResultsList
  getDocumentResultsList: () ->
    if not @documentResultsList
      @documentResultsList = new DocumentResultsList
    return @documentResultsList

  # --------------------------------------------------------------------------------------------------------------------
  # Functions
  # --------------------------------------------------------------------------------------------------------------------

  # coordinates the search across the different
  search: () ->
    if @searchCompounds
      # TODO: pass query parameters to @getCompoundResultsList().search(queryString)
      @getCompoundResultsList().fetch({reset:true})
    if @searchDocuments
      # TODO: pass query parameters to @getCompoundResultsList().search(queryString)
      @getDocumentResultsList().fetch({reset:true})

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance
