# This model defines the simple and advanced search fields,
# and it is in charge of coordinating the query among the other models
SearchModel = Backbone.Model.extend

  # --------------------------------------------------------------------------------------------------------------------
  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

  defaults:
    resultsListsDict: null
    queryString: ''
    chembl_ids: []
    inchi_keys: []
    smiles: []
    smiles_regex: /^([^J][0-9BCcOHNSOPrIFla@+\-\[\]\(\)\\\/%=#$~&!]{6,})$/g

  # --------------------------------------------------------------------------------------------------------------------
  # Models
  # --------------------------------------------------------------------------------------------------------------------

  # Lazily initialized CompoundResultsList
  getResultsListsDict: () ->
    if not @has('resultsListsDict')
      @set('resultsListsDict',
          glados.models.paginatedCollections.PaginatedCollectionFactory.getAllESResultsListDict())
    return @get('resultsListsDict')

  # --------------------------------------------------------------------------------------------------------------------
  # Functions
  # --------------------------------------------------------------------------------------------------------------------

  checkUniCHEM: (term, callback_response)->
#    TODO: Change when UniChem accepts the CORS headers
    callback_unichem = (uc_json_response)->
      tmp_chembl_id = null
      if _.has(uc_json_response, 'error')
        console.log('unichem: not found for '+term)
      else
        tmp_chembl_id = uc_json_response[_.keys(uc_json_response)[0]][0].src_compound_id
      callback_response(term, tmp_chembl_id)
    window.unichem_cb = callback_unichem.bind(@)
    $.ajax( {
        type: 'GET'
        url: 'https://www.ebi.ac.uk/unichem/rest/orphanIdMap/'+encodeURI(term)+'/1?callback=unichem_cb'
        jsonp: 'unichem_cb'
        dataType: 'jsonp'
        headers:
          'Accept':'application/json'
        error: ()->
          callback_response(term, null)
      }
    )

  parseQueryStringAndSearch: (rawQueryString)->
    final_cb = @__search.bind(@)
    terms = rawQueryString.split(" ")
    query_str = ""
#    parameterTransformCB = (term_resp, chmebl_id_resp)->
#      query_str += if chembl_id then chembl_id else term

    for term in terms
      if term.match(@smiles_regex)
        query_str += '"'+term+'"'
      else
        query_str += term
#      @checkUniCHEM(term, )
#      query_str += " "
    @set('queryString', query_str)
    final_cb()

  __search: ()->
    rls_dict = @getResultsListsDict()
    for key_i, val_i of rls_dict
      val_i.setMeta('search_term',@get('queryString'))
      val_i.fetch()

  # coordinates the search across the different results lists
  search: (rawQueryString) ->
    @parseQueryStringAndSearch(rawQueryString)

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance

