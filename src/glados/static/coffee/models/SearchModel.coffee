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
      chembl_ids_terms = []
      if _.has(uc_json_response, 'error')
        console.log('unichem: not found for '+term)
      else
        num_ids = _.keys(uc_json_response).length
        for key_i, key_index in _.keys(uc_json_response)
          chembl_ids_terms.push('"'+uc_json_response[key_i][0].src_compound_id+'"'+
              '^'+(1+(num_ids-key_index)/num_ids).toFixed(3)
          )
      if chembl_ids_terms
        callback_response(chembl_ids_terms, index)
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
        url: glados.Settings.WS_BASE_FLEXMATCH_SEARCH_URL+encodeURI(term)
        success: (data)->
          if data and _.has(data,'molecules')
            chembl_ids_terms = []
            num_ids = data.molecules.length
            for molecule_i, molecule_index in data.molecules
              chembl_ids_terms.push('"'+molecule_i.molecule_chembl_id+'"'+
                  '^'+(1+(num_ids-molecule_index)/num_ids).toFixed(3)
              )
            if chembl_ids_terms
              callback_response(chembl_ids_terms, index)
              Number()
        error: ()->
          return
      }
    )
    return jQueryPromise

  getStringTerms: (rawQueryString)->
    valid_separators = /[,|;]/
    cleansed_terms = []
    # Removes invalid characters
    # removes multiple spaces
    # adds 1 trailing and 1 heading space to simplify terms regex
    rawQueryString = rawQueryString.replace(/[^\x20-\x7E]+/g, ' ');
    rawQueryString = ' '+rawQueryString.replace(/\s+/g,' ').trim()+' '
    regex_terms = /\s((?:".+?")|(?:\S+))(?=\s)/g
    terms_by_regex = []
    match_arr = null
    while (match_arr = regex_terms.exec(rawQueryString)) != null
      terms_by_regex.push(match_arr[1])
    for term_i in terms_by_regex
      if term_i
        if glados.ChemUtils.InChI.regex.test(term_i)
          cleansed_terms.push(term_i)
        else
          subterms = term_i.split(valid_separators)
          for subterm_i in subterms
            if subterm_i
              cleansed_terms.push(subterm_i)
    return cleansed_terms

  parseQueryString: (rawQueryString, callback)->
    terms = @getStringTerms(rawQueryString)
    console.log(terms)
    @set('queryString', terms.join(' '))

    terms_transform_in_order = terms.slice(0)

    final_cb = ()->
      singular_terms = []
      exact_terms = []
      filter_terms = []
      classify_term = (term_2_classify)->
        if SearchModel.EXACT_TERM_REGEX.test(term_2_classify)
          exact_terms.push(term_2_classify)
        else if SearchModel.PROPERTY_TERM_REGEX.test(term_2_classify)
          filter_terms.push(term_2_classify)
        else
          singular_terms.push(term_2_classify)

      for term, index in terms_transform_in_order
        if _.isArray(term)
          for subterm in term
            classify_term(subterm)
        else if term.trim()
          classify_term(term)
      console.log("singular",singular_terms)
      console.log("exact",exact_terms)
      console.log("filter_terms",filter_terms)
      @set("singular_terms",singular_terms)
      @set("exact_terms",exact_terms)
      @set("filter_terms",filter_terms)
      setTimeout(callback,10)
    final_cb = final_cb.bind(@)

    term_replacement_callback = (termReplacement,term_pos)->
      terms_transform_in_order[term_pos] = termReplacement
    jquery_promises = []
    for term, index in terms
      if (SearchModel.EXACT_TERM_REGEX).test(term)
        # replaces internal double quotation if found
        term = term.slice(1,-1).replace(/"/g,'\\"')
        terms_transform_in_order[index] = SearchModel.toExactTerm(term)
      else if SearchModel.PROPERTY_TERM_REGEX.test(term)
        terms_transform_in_order[index] = term
      else if (/^\d+$/).test(term)
        if term.length > 2
          terms_transform_in_order.push(SearchModel.toExactTerm(term))
        terms_transform_in_order[index] = ''
        terms_transform_in_order.push(SearchModel.toExactTerm('CHEMBL'+term)+"^3")
        unichem_promise = @checkUniCHEM(term,term_replacement_callback, index)
        jquery_promises.push(unichem_promise)
      else if (glados.ChemUtils.CHEMBL.id_regex).test(term)
        terms_transform_in_order[index] = SearchModel.toExactTerm(
          'CHEMBL'+glados.ChemUtils.CHEMBL.id_regex.exec(term)[1]
        )
      else if glados.ChemUtils.DOI.regex.test(term)
        terms_transform_in_order[index] = SearchModel.toExactTerm(term)
      else if glados.ChemUtils.InChI.regex.test(term) or glados.ChemUtils.InChI.key_regex.test(term)
        terms_transform_in_order[index] = SearchModel.toExactTerm(term)
      else if glados.ChemUtils.SMILES.regex.test(term)
        terms_transform_in_order[index] = SearchModel.toExactTerm(term)
        smiles_promise = @flexmatchSMILES(term,term_replacement_callback, index)
        jquery_promises.push(smiles_promise)
      else if term
        unichem_promise = @checkUniCHEM(term,term_replacement_callback, index)
        jquery_promises.push(unichem_promise)
    if jquery_promises.length > 0
      $.when.apply($,jquery_promises).always(final_cb)
    else
      final_cb()


  __search: ()->
    console.log("MODEL SEARCH")
    rls_dict = @getResultsListsDict()
    for key_i, val_i of rls_dict
      val_i.setMeta('singular_terms',@get("singular_terms"))
      val_i.setMeta('exact_terms',@get("exact_terms"))
      val_i.setMeta('filter_terms',@get("filter_terms"))
      val_i.setPage(1)
      val_i.fetch()

  # coordinates the search across the different results lists
  search: (rawQueryString) ->
    @parseQueryString(rawQueryString, @__search.bind(@))

# --------------------------------------------------------------------------------------------------------------------
# CONSTANTS
# --------------------------------------------------------------------------------------------------------------------

SearchModel.EXACT_TERM_REGEX = /^".*"(\^\d+(\.\d+)?)?$/
SearchModel.PROPERTY_TERM_REGEX = /^(\+|-)?[A-Za-z0-9_\-]+:[A-Za-z0-9_()\[\]\\/\-]+$/
SearchModel.toExactTerm = (term) -> return "\""+term+"\""

# ----------------------------------------------------------------------------------------------------------------------
# Singleton pattern
# ----------------------------------------------------------------------------------------------------------------------

SearchModel.getInstance = () ->
  if not SearchModel.__model_instance
    SearchModel.__model_instance = new SearchModel
  return SearchModel.__model_instance

