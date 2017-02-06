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

  checkUniCHEM: (term, callback_response, index)->
    # TODO: Change when UniChem accepts the CORS headers
    callback_unichem = (uc_json_response)->
      tmp_chembl_id = null
      if _.has(uc_json_response, 'error')
        console.log('unichem: not found for '+term)
      else
        tmp_chembl_id = uc_json_response[_.keys(uc_json_response)[0]][0].src_compound_id
      if tmp_chembl_id
        callback_response('"'+tmp_chembl_id+'"', index)
    # Hack to prevent all callbacks to point to the same function with overriden index position
    callback_unichem.index_pos = index
    unichem_cb_name = 'unichem_cb_'+index
    window[unichem_cb_name] = callback_unichem
    jQueryPromise = $.ajax( {
        type: 'GET'
        url: glados.ChemUtils.UniChem.orphaned_id_url+encodeURI(term)+'/1?callback='+unichem_cb_name
        jsonp: unichem_cb_name
        dataType: 'jsonp'
        headers:
          'Accept':'application/json'
        error: ()->
          return
      }
    )
    return jQueryPromise

  canonicalizeSMILE: (term, callback_response, index)->
    jQueryPromise = $.ajax( {
        type: 'POST'
        url: glados.ChemUtils.SMILES.canonicalize_ws_url
        data: term
        success: (data)->
          if data
            parts=data.split('\n')
            if parts[1]
              callback_response('"'+parts[1].trim()+'"', index)
        error: ()->
          return
      }
    )
    return jQueryPromise


  parseQueryStringAndSearch: (rawQueryString)->

    terms = rawQueryString.split(" ")

    terms_transform_in_order = terms.slice(0)

    final_cb = ()->
      @set('queryString', terms_transform_in_order.join(' '))
      setTimeout(@__search.bind(@),10)
    final_cb = final_cb.bind(@)

    term_replacement_callback = (termReplacement,term_pos)->
      terms_transform_in_order[term_pos] = termReplacement
    jquery_promises = []
    for term, index in terms
      if (/^".*"$/g).test(term)
        console.log("SKIPPED:"+term)
        continue
      if glados.ChemUtils.InChI.regex.test(term) or glados.ChemUtils.InChI.key_regex.test(term)
        terms_transform_in_order[index] = '"'+term+'"'
      else if glados.ChemUtils.SMILES.regex.test(term)
        terms_transform_in_order[index] = '"'+term+'"'
        smiles_promise = @canonicalizeSMILE(term,term_replacement_callback, index)
        jquery_promises.push(smiles_promise)
      else
        unichem_promise = @checkUniCHEM(term,term_replacement_callback, index)
        jquery_promises.push(unichem_promise)
    $.when(jquery_promises).then(
      setTimeout(final_cb,300)
    )


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

