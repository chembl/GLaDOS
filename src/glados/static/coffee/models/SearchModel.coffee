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
      chembl_ids = []
      if _.has(uc_json_response, 'error')
        console.log('unichem: not found for '+term)
      else
        for key_i in _.keys(uc_json_response)
          chembl_ids.push('"'+uc_json_response[key_i][0].src_compound_id+'"')
      if chembl_ids
        callback_response(chembl_ids.join(' '), index)
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

  flexmatchSMILES: (term, callback_response, index)->
    jQueryPromise = $.ajax( {
        type: 'GET'
        url: glados.Settings.WS_BASE_FLEXMATCH_SEARCH_URL+term
        success: (data)->
          if data and _.has(data,'molecules')
            chembl_ids = []
            for molecule_i in data.molecules
              chembl_ids.push('"'+molecule_i.molecule_chembl_id+'"')
            if chembl_ids
              callback_response(chembl_ids.join(' '), index)
        error: ()->
          return
      }
    )
    return jQueryPromise


  parseQueryStringAndSearch: (rawQueryString)->
    @set('queryString','')
    terms = rawQueryString.split(" ")

    terms_transform_in_order = terms.slice(0)
    chembl_ids = []

    final_cb = ()->
      singular_terms = []
      exact_terms = []
      search_str_page = ""
      for term, index in terms_transform_in_order
        if term.trim()
          search_str_page += term
          if (/^".*"$/).test(term)
            exact_terms.push(term)
          else
            singular_terms.push(term)
      console.log(singular_terms)
      console.log(exact_terms)
      @set("singular_terms",singular_terms)
      @set("exact_terms",exact_terms)
      @set('queryString', search_str_page)
      setTimeout(@__search.bind(@),10)
    final_cb = final_cb.bind(@)

    term_replacement_callback = (termReplacement,term_pos)->
      terms_transform_in_order[term_pos] = termReplacement
    jquery_promises = []
    for term, index in terms
      if (/^".*"$/).test(term)
        console.log("SKIPPED:"+term)
        continue
      if glados.ChemUtils.DOI.regex.test(term)
        terms_transform_in_order[index] = '"'+term+'"'
      else if glados.ChemUtils.InChI.regex.test(term) or glados.ChemUtils.InChI.key_regex.test(term)
        terms_transform_in_order[index] = '"'+term+'"'
      else if glados.ChemUtils.SMILES.regex.test(term)
        terms_transform_in_order[index] = '"'+term+'"'
        smiles_promise = @flexmatchSMILES(term,term_replacement_callback, index)
        jquery_promises.push(smiles_promise)
      else if term
        unichem_promise = @checkUniCHEM(term,term_replacement_callback, index)
        jquery_promises.push(unichem_promise)
    $.when(jquery_promises).done(
      setTimeout(final_cb,300)
    )


  __search: ()->
    console.log("MODEL SEARCH")
    rls_dict = @getResultsListsDict()
    for key_i, val_i of rls_dict
      val_i.setMeta('singular_terms',@get("singular_terms"))
      val_i.setMeta('exact_terms',@get("exact_terms"))
      val_i.setPage(1)
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

