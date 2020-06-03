glados.useNameSpace 'glados.models.paginatedCollections.esSchema',

  FacetsConfigurationModel: Backbone.Model.extend

    initialize: ->

      @url = glados.Settings.FACETS_GROUP_CONFIGURATION_URL_GENERATOR
        index_name: @get('index_name')
        group_name: @get('group_name')

    parse: (response) ->

      facetsConfig = {}
      facetsConfigWithHandler = {}

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
        configWithHandler = Object.assign({}, parsedConfig)
        @generateFacetingHandler(configWithHandler, propConfig)
        console.log('configWithHandler: ', configWithHandler)

        facetsConfig[propConfig.prop_id] = parsedConfig
        facetsConfigWithHandler[propConfig.prop_id] = configWithHandler
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
        configWithHandler = Object.assign({}, parsedConfig)
        @generateFacetingHandler(configWithHandler, propConfig)
        console.log('configWithHandler: ', configWithHandler)

        facetsConfig[propConfig.prop_id] = parsedConfig
        facetsConfigWithHandler[propConfig.prop_id] = configWithHandler
        i += 1

      return {
        'facets_config': facetsConfig
        'facets_config_with_handler': facetsConfigWithHandler
      }

    ENTITY_NAME_TO_REPORT_CARD_ENTITY:
      'Compound': Compound
      'Target': Target
      'Document': Document
      'Assay': Assay

    generateFacetingHandler: (parsedConfig, propConfig) ->

      console.log('GENERATING FACEINT HANDLER')
      property_type = propConfig.property_config.type
      console.log('property_type: ', property_type)

      if property_type == 'string'
        js_property_type = String
      else if property_type == 'boolean'
        js_property_type = Boolean
      else if property_type == 'integer' or property_type == 'double' or property_type == 'date'
        js_property_type = Number

      es_index = @get('index_name')
      es_property = propConfig.prop_id
      sort = if propConfig.agg_config.agg_params.initial_sort? then propConfig.agg_config.agg_params.initial_sort else null
      intervals = if propConfig.agg_config.agg_params.initial_intervals? then propConfig.agg_config.agg_params.initial_intervals else null
      report_card_entity = if propConfig.agg_config.agg_params.report_card_entity? then @ENTITY_NAME_TO_REPORT_CARD_ENTITY[propConfig.agg_config.agg_params.report_card_entity] else null

      old_obfuscated_type =
        type : js_property_type
        integer : js_property_type == Number
        year : false # review this one!!!
        aggregatable : propConfig.property_config.aggregatable


      if property_type == 'string' or property_type == 'boolean'
        parsedConfig.faceting_handler = new FacetingHandler(
          es_index,
          es_property,
          js_property_type,
          FacetingHandler.CATEGORY_FACETING,
          old_obfuscated_type,
          null,
          sort,
          intervals,
          report_card_entity
        )
      else if property_type == 'integer' or property_type == 'double' or property_type == 'date'
        parsedConfig.faceting_handler = new FacetingHandler(
          es_index,
          es_property,
          js_property_type,
          FacetingHandler.INTERVAL_FACETING,
          old_obfuscated_type,
          js_property_type.year,
          sort,
          intervals,
          report_card_entity
        )
      else
        throw "ERROR! "+propConfig.prop_id+" for elastic index "+es_index+" with type "+property_type.type\
            +" does not have a defined faceting type"
