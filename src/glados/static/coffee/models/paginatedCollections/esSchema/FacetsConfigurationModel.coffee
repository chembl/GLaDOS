glados.useNameSpace 'glados.models.paginatedCollections.esSchema',

  FacetsConfigurationModel: Backbone.Model.extend

    initialize: ->

      @url = glados.Settings.FACETS_GROUP_CONFIGURATION_URL_GENERATOR
        index_name: @get('index_name')
        group_name: @get('group_name')