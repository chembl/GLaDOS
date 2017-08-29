glados.useNameSpace 'glados.views.SearchResults',

  URLFunctions:

    getSearchURLFor: (es_settings_key, search_str) ->
      selected_es_entity_path = if es_settings_key then \
                                '/'+glados.Settings.ES_KEY_2_SEARCH_PATH[es_settings_key] else ''
      search_url_for_query = glados.Settings.SEARCH_RESULTS_PAGE+\
                              selected_es_entity_path+\
                              '/'+encodeURI(search_str)
      return search_url_for_query

    getCurrentSearchURL: -> @getSearchURLFor(@selected_es_entity, @expandable_search_bar.val())