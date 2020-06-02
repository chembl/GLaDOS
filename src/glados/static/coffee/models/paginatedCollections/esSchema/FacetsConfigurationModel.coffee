glados.useNameSpace 'glados.models.paginatedCollections.esSchema',

  FacetsConfigurationModel: Backbone.Model.extend

    initialize: ->

      @url = glados.Settings.FACETS_GROUP_CONFIGURATION_URL_GENERATOR
        index_name: @get('index_name')
        group_name: @get('group_name')

    parse: (response) ->

      console.log('PARSING RESONSE')
      console.log(response)
      facetsConfig = {}

      propertiesFacetConfig = response.properties
      defaultProperties = propertiesFacetConfig.default
      optionalProperties = propertiesFacetConfig.optional

      i = 1
      for propConfig in defaultProperties

        parsedConfig = {
          prop_id: propConfig.prop_id
          prop_name: propConfig.prop_id
          label: propConfig.property_config.label
          label_mini: propConfig.property_config.label_mini
          show: true
          position: i
          es_index: @get('index_name')
          initial_sort: if propConfig.agg_config.agg_params.initial_sort? then propConfig.agg_config.agg_params.initial_sort else null
          initial_intervals: if propConfig.agg_config.agg_params.initial_intervals? then propConfig.agg_config.agg_params.initial_intervals else null
          report_card_entity: if propConfig.agg_config.agg_params.report_card_entity? then @ENTITY_NAME_TO_REPORT_CARD_ENTITY[propConfig.agg_config.agg_params.report_card_entity] else null
        }

        facetsConfig[propConfig.prop_id] = parsedConfig
        i += 1

      for propConfig in optionalProperties

        parsedConfig = {
          prop_id: propConfig.prop_id
          prop_name: propConfig.prop_id
          label: propConfig.property_config.label
          label_mini: propConfig.property_config.label_mini
          show: false
          position: i
          es_index: @get('index_name')
          initial_sort: if propConfig.agg_config.agg_params.initial_sort? then propConfig.agg_config.agg_params.initial_sort else null
          initial_intervals: if propConfig.agg_config.agg_params.initial_intervals? then propConfig.agg_config.agg_params.initial_intervals else null
          report_card_entity: if propConfig.agg_config.agg_params.report_card_entity? then @ENTITY_NAME_TO_REPORT_CARD_ENTITY[propConfig.agg_config.agg_params.report_card_entity] else null
        }

        facetsConfig[propConfig.prop_id] = parsedConfig
        i += 1

      return facetsConfig

    ENTITY_NAME_TO_REPORT_CARD_ENTITY:
      'Compound': Compound
      'Target': Target
      'Document': Document
      'Assay': Assay