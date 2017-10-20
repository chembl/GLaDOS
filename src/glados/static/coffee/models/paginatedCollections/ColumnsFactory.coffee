glados.useNameSpace 'glados.models.paginatedCollections',
  ColumnsFactory:
    #the baseConfig MUST have a comparator, from there it will do the rest
    generateColumn: (indexName, baseConfig) ->

      gladosSchema = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema
      gladosConfig = gladosSchema[indexName][baseConfig.comparator]

      inferredProperties = {}

      if gladosConfig.aggregatable
        inferredProperties.sort_disabled = false
        inferredProperties.is_sorting = 0
        inferredProperties.sort_class = 'fa-sort'
      else
        inferredProperties.sort_disabled = true

      finalConfig = _.extend({}, gladosConfig, inferredProperties, baseConfig)
      return finalConfig