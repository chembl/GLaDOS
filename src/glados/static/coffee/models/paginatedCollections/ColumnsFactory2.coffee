glados.useNameSpace 'glados.models.paginatedCollections',
  ColumnsFactory2:

    ENTITY_NAME_TO_ENTITY_MODEL:
      "#{Compound.ES_INDEX}": Compound
      "#{Target.ES_INDEX}": Target
      "#{Assay.INDEX_NAME}": Assay
      "#{Document.INDEX_NAME}": Document
      "#{CellLine.INDEX_NAME}": CellLine

    generateColumn: (configFromServer, customEntity) ->

      propID = configFromServer.prop_id

      indexName = configFromServer.index_name
      if customEntity?
        entity = customEntity
      else
        entity = glados.models.paginatedCollections.ColumnsFactory2.ENTITY_NAME_TO_ENTITY_MODEL[indexName]

      visualConfig = entity.PROPERTIES_VISUAL_CONFIG[propID]
      if not visualConfig?
        console.warn("There is no visual config for the property #{propID}, of index #{indexName}")
        visualConfig = {}

      inferredProperties = {}

      if configFromServer.aggregatable
        inferredProperties.sort_disabled = false
        inferredProperties.is_sorting = 0
        inferredProperties.sort_class = 'fa-sort'
      else
        inferredProperties.sort_disabled = true

      basedOn = configFromServer.based_on
      if basedOn?
        inferredProperties.comparator = basedOn
      else
        inferredProperties.comparator = propID

      inferredProperties.name_to_show = configFromServer.label
      inferredProperties.name_to_show_short = configFromServer.label_mini
      inferredProperties.id = configFromServer.prop_id

      finalConfig = _.extend({show:true}, configFromServer, inferredProperties, visualConfig)
      return finalConfig

    getSearchResultsHighlightColumn: () ->
      srhColumn= {
        sort_disabled: true
        name_to_show: 'Search Hit'
        id: 'glados_search_hit_highlight'
        search_hit_highlight_column: true
        show: true
        comparator: '_highlights'
      }
      return srhColumn