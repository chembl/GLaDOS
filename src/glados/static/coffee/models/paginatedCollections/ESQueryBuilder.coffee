glados.useNameSpace 'glados.models.paginatedCollections',

  # --------------------------------------------------------------------------------------------------------------------
  # This class implements the functionalities to build an Elastic Search query
  # --------------------------------------------------------------------------------------------------------------------
  ESQueryBuilder: class ESQueryBuilder

    @TEXT_FIELDS_BOOSTS: [
      "*.std_analyzed^1.6",
      "*.eng_analyzed^0.8",
      "*.ws_analyzed^1.4",
      "*.keyword^2",
      "*.lower_case_keyword^1.5",
      "*.alphanumeric_lowercase_keyword^1.3"
    ]

    @ID_FIELDS_BOOSTS: [
      "*.entity_id^2",
      "*.id_reference^1.5",
      "*.chembl_id^2",
      "*.chembl_id_reference^1.5"
    ]

    @getESTextTermQueries: (queryString, fuzzy, minimumShouldMatch)->
      queries = [
        {
          multi_match:
            type: "most_fields"
            fields: ESQueryBuilder.TEXT_FIELDS_BOOSTS
            query: queryString
            fuzziness: 0
            minimum_should_match: minimumShouldMatch
            boost: 10
            fuzziness: if fuzzy then 'AUTO' else 0
        },
        {
          multi_match:
            type: "best_fields"
            fields: ESQueryBuilder.TEXT_FIELDS_BOOSTS
            query: queryString
            fuzziness: 0
            minimum_should_match: minimumShouldMatch
            boost: 2
            fuzziness: if fuzzy then 'AUTO' else 0
        }
      ]
      if not fuzzy
        queries.push(
          {
            multi_match:
              type: "phrase"
              fields: ESQueryBuilder.TEXT_FIELDS_BOOSTS
              query: queryString
              minimum_should_match: minimumShouldMatch
              boost: 1.5
          }
        )
        queries.push(
          {
            multi_match:
              type: "phrase_prefix"
              fields: ESQueryBuilder.TEXT_FIELDS_BOOSTS
              query: queryString
              minimum_should_match: minimumShouldMatch
          }
        )
      return queries

    @getESIdTermQueries: (terms, fuzzy, minimumShouldMatch)->
      queries = []
      for termI in terms
        if termI.length >= 3
          queries.push(
            {
              multi_match:
                type: "most_fields"
                fields: ESQueryBuilder.ID_FIELDS_BOOSTS
                query: termI
                fuzziness: if fuzzy then 'AUTO' else 0
                boost: 10
            }
          )
      return queries

    @getESQueryFor: (chemblIds, terms, filterTerms, subQueries, fuzzy, minimumShouldMatch, isOr=true)->
      delta = 0.3/chemblIds.length
      queryString = terms.join(' ')
      filterTermsJoined = filterTerms.join(' AND ')
      query = {
        bool:
          must:
            bool:
              should: []
              must: []
          filter:[]
      }
      boolQuery = if isOr then 'should'else 'must'
      if queryString
        query.bool.must.bool[boolQuery] = query.bool.must.bool[boolQuery].concat(
          ESQueryBuilder.getESTextTermQueries(queryString, fuzzy, minimumShouldMatch)
        )
        query.bool.must.bool[boolQuery] = query.bool.must.bool[boolQuery].concat(
          ESQueryBuilder.getESIdTermQueries(terms, fuzzy, minimumShouldMatch)
        )

      chemblIdsEt = []
      for cIdI, i in chemblIds
        chemblIdsEt.push('"'+cIdI+'"'+'^'+(1.3-i*delta))
      if chemblIdsEt.length > 0
        query.bool.must.bool[boolQuery].push(
          {
            query_string:
              fields: ESQueryBuilder.TEXT_FIELDS_BOOSTS.concat(ESQueryBuilder.ID_FIELDS_BOOSTS)
              query: chemblIdsEt.join(' ')
              allow_leading_wildcard: false
              fuzziness: 0
              use_dis_max: false
          }
        )
      if filterTermsJoined
        query.bool.filter.push({
          query_string:
            fields: ESQueryBuilder.TEXT_FIELDS_BOOSTS.concat ESQueryBuilder.ID_FIELDS_BOOSTS
            query: filterTermsJoined
        })
      if subQueries
        query.bool.must.bool[boolQuery] = query.bool.must.bool[boolQuery].concat(subQueries)
      return query

    @buildParsedQueryRecursive: (curParsedQuery, chemblIds, terms, filterTerms, fuzzy, minimumShouldMatch)->
      # Query tree leafs
      if _.has(curParsedQuery, 'term')
        if curParsedQuery.chembl_entity and _.has(
          glados.Settings.SEARCH_PATH_2_ES_KEY,
          curParsedQuery.chembl_entity
        )
          entityBoost = curParsedQuery.chembl_entity
        if curParsedQuery.include_in_query
          if curParsedQuery.exact_match_term
            terms.push(curParsedQuery.term)
            filterTerms.push(curParsedQuery.term)
          else if curParsedQuery.filter_term
            filterTerms.push(curParsedQuery.term)
          else
            terms.push(curParsedQuery.term)
        for refI in curParsedQuery.references
          if refI.include_in_query
            for chemblIdI in refI.chembl_ids
              if chemblIdI.include_in_query
                chemblIds.push(chemblIdI.chembl_id)
        return null

      chemblIds = []
      terms = []
      filterTerms = []

      nextTerms = []
      curType = null
      if _.has(curParsedQuery, 'or')
        nextTerms = curParsedQuery.or
        curType = 'or'
      if _.has(curParsedQuery, 'and')
        nextTerms = curParsedQuery.and
        curType = 'and'

      innerQueries = []
      for termI in nextTerms
        termQuery = ESQueryBuilder.buildParsedQueryRecursive(
          termI, chemblIds, terms, filterTerms, fuzzy, minimumShouldMatch, curType
        )
        if termQuery
          innerQueries.push(termQuery)
      return ESQueryBuilder.getESQueryFor(
        chemblIds, terms, filterTerms, innerQueries, fuzzy, minimumShouldMatch, curType == 'or'
      )

    @getESQueryForJsonQuery: (jsonQuery, fuzzy=false, minimumShouldMatch='100%')->
      chemblIds = []
      terms = []
      filterTerms = []
      esQuery= ESQueryBuilder.buildParsedQueryRecursive(
        jsonQuery, chemblIds, terms, filterTerms, fuzzy, minimumShouldMatch
      )
      if not esQuery
        esQuery = ESQueryBuilder.getESQueryFor(chemblIds, terms, filterTerms, [], fuzzy, minimumShouldMatch)
      return esQuery
