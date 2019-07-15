glados.useNameSpace 'glados.models.paginatedCollections.esSchema',

  PropertiesConfigurationModel: Backbone.Model.extend

    initialize: ->

      @url = glados.Settings.PROPERTIES_GROUP_CONFIGURATION_URL_GENERATOR
        index_name: @get('index_name')
        group_name: @get('group_name')

    parse: (response) ->

      parsedConfiguration = {}
      for subGroupKey, subGroup of response.properties

        parsedProperties = []
        for propertyDescription in subGroup
          parsedProperty = glados.models.paginatedCollections.ColumnsFactory2.generateColumn(propertyDescription)
          parsedProperties.push(parsedProperty)

        if subGroupKey == 'default'
          parsedConfiguration.Default = parsedProperties
        else if subGroupKey == 'optional'
          parsedConfiguration.Additional = parsedProperties

      @set('parsed_configuration', parsedConfiguration)
