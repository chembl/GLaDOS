glados.useNameSpace 'glados.models.paginatedCollections',
  ColumnsFactory:
    #the baseConfig MUST have a comparator, from there it will do the rest
    generateColumn: (indexName, baseConfig) ->

      gladosSchema = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema
      gladosConfig = gladosSchema[indexName][baseConfig.comparator]

      inferedProperties = {}

      if gladosConfig.aggregatable
        inferedProperties.sort_disabled = false
        inferedProperties.is_sorting = 0
        inferedProperties.sort_class = 'fa-sort'

      finalConfig = _.extend({}, gladosConfig, inferedProperties, baseConfig)
      return finalConfig