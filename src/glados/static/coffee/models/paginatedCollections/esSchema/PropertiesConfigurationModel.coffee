glados.useNameSpace 'glados.models.paginatedCollections.esSchema',

  PropertiesConfigurationModel: Backbone.Model.extend

    initialize: ->

      @url = glados.Settings.PROPERTIES_GROUP_CONFIGURATION_URL_GENERATOR
        index_name: @get('index_name')
        group_name: @get('group_name')

      console.log 'URL', @url