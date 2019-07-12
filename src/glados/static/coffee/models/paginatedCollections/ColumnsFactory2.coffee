glados.useNameSpace 'glados.models.paginatedCollections',
  ColumnsFactory2:

    ENTITY_NAME_TO_ENTITY_MODEL:
      "#{Compound.INDEX_NAME}": Compound

    generateColumn: (configFromServer) ->

      propID = configFromServer.prop_id

      indexName = configFromServer.index_name
      console.log(glados.models.paginatedCollections.ColumnsFactory2.ENTITY_NAME_TO_ENTITY_MODEL)
      entity = glados.models.paginatedCollections.ColumnsFactory2.ENTITY_NAME_TO_ENTITY_MODEL[indexName]
      visualConfig = entity.PROPERTIES_VISUAL_CONFIG[propID]

      inferredProperties = {}

      if configFromServer.aggregatable
        inferredProperties.sort_disabled = false
        inferredProperties.is_sorting = 0
        inferredProperties.sort_class = 'fa-sort'
      else
        inferredProperties.sort_disabled = true

      inferredProperties.name_to_show = configFromServer.label
      inferredProperties.name_to_show_short = configFromServer.label_mini
      inferredProperties.id = configFromServer.prop_id

      finalConfig = _.extend({show:true}, configFromServer, inferredProperties, visualConfig)
      return finalConfig