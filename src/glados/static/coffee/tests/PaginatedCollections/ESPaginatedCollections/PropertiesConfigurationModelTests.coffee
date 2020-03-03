describe 'PropertiesConfigurationModel', ->
  sampleResponse = {
    "properties": {
      "optional": [
        {
          "type": "string",
          "label": "Name",
          "aggregatable": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "sortable": true,
          "label_mini": "Name",
          "prop_id": "pref_name"
        }
      ],
      "default": [
        {
          "type": "string",
          "label": "ChEMBL ID",
          "aggregatable": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "sortable": true,
          "label_mini": "ChEMBL ID",
          "prop_id": "molecule_chembl_id"
        }
      ]
    }
  }

  sampleResponse2 = {
    "properties": {
      "optional": [
        {
          "aggregatable": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "type": "double",
          "sortable": true,
          "label": "CX BpKa",
          "label_mini": "Cx Most Bpka",
          "prop_id": "molecule_properties.cx_most_bpka"
        },
        {
          "aggregatable": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "type": "double",
          "sortable": true,
          "label": "CX ApKa",
          "label_mini": "Cx Most Apka",
          "prop_id": "molecule_properties.cx_most_apka"
        },
        {
          "type": "string",
          "label": "Name",
          "aggregatable": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "sortable": true,
          "label_mini": "Name",
          "prop_id": "pref_name"
        }
      ],
      "default": [
        {
          "aggregatable": false,
          "is_virtual": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "is_contextual": true,
          "type": "double",
          "sortable": true,
          "label": "Similarity",
          "label_mini": "Similarity",
          "prop_id": "similarity"
        },
        {
          "type": "string",
          "label": "ChEMBL ID",
          "aggregatable": true,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "sortable": true,
          "label_mini": "ChEMBL ID",
          "prop_id": "molecule_chembl_id"
        },
        {
          "aggregatable": false,
          "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
          "type": "object",
          "sortable": false,
          "label": "Synonyms",
          "label_mini": "Synonyms",
          "prop_id": "molecule_synonyms"
        },
      ]
    }
  }

  parsedConfigMustBe = {
    "Additional": [
      {
        "show": true,
        "type": "string",
        "label": "Name",
        "aggregatable": true,
        "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
        "sortable": true,
        "label_mini": "Name",
        "prop_id": "pref_name",
        "sort_disabled": false,
        "is_sorting": 0,
        "sort_class": "fa-sort",
        "name_to_show": "Name",
        "name_to_show_short": "Name",
        "id": "pref_name",
        "comparator": "pref_name"
      }
    ],
    "Default": [
      {
        "show": true,
        "type": "string",
        "label": "ChEMBL ID",
        "aggregatable": true,
        "index_name": glados.Settings.CHEMBL_ES_INDEX_PREFIX+"molecule",
        "sortable": true,
        "label_mini": "ChEMBL ID",
        "prop_id": "molecule_chembl_id",
        "sort_disabled": false,
        "is_sorting": 0,
        "sort_class": "fa-sort",
        "name_to_show": "ChEMBL ID",
        "name_to_show_short": "ChEMBL ID",
        "id": "molecule_chembl_id",
        "comparator": "molecule_chembl_id",
        "link_base": "report_card_url",
        "image_base_url": "image_url",
        "hide_label": true
      }
    ]
  }

  it 'Generates the correct url', ->
    indexName = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
    groupName = 'browser_table'

    propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
      index_name: indexName
      group_name: groupName

    urlMustBe = glados.Settings.PROPERTIES_GROUP_CONFIGURATION_URL_GENERATOR
      index_name: indexName
      group_name: groupName

    urlGot = propertiesConfigModel.url
    expect(urlMustBe).toBe(urlGot)

  it 'Parses the response correctly', ->
    indexName = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
    groupName = 'browser_table'

    propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
      index_name: indexName
      group_name: groupName

    parsedResponse = propertiesConfigModel.parse(sampleResponse)
    parsedConfigGot = parsedResponse['parsed_configuration']

    expect(_.isEqual(parsedConfigGot, parsedConfigMustBe)).toBe(true)

    propComparatorsSetMustBe = {
      'molecule_chembl_id': 'molecule_chembl_id',
      'pref_name': 'pref_name'
    }

    propsComparatorsSetGot = parsedResponse['props_comparators_set']

    expect(_.isEqual(propComparatorsSetMustBe, propsComparatorsSetGot)).toBe(true)

  it 'Identifies the comparators to be used in the text filers', ->

    canBeUsedInTextFilter = (propDesc) -> propDesc.type in ['string', 'object'] and propDesc.is_contextual != true
    comparatorsFromOptional = _.filter(sampleResponse2.properties.optional, canBeUsedInTextFilter)
    comparatorsFromDefault = _.filter(sampleResponse2.properties.default, canBeUsedInTextFilter)

    comparatorsInFilterList = []
    for propDesc in _.union(comparatorsFromOptional, comparatorsFromDefault)
      baseComparator = propDesc.prop_id
      comparatorsInFilterList.push(baseComparator)

      for field in ['eng_analyzed', 'std_analyzed', 'ws_analyzed', 'alphanumeric_lowercase_keyword']
        if propDesc.type == 'string'
          comparatorForTextFilter = "#{baseComparator}.#{field}"
        else
          comparatorForTextFilter = "#{baseComparator}.*.#{field}"

        comparatorsInFilterList.push(comparatorForTextFilter)

    comparatorsInFilterMustBe = {}
    for comp in comparatorsInFilterList
      comparatorsInFilterMustBe[comp] = comp

    indexName = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'molecule'
    groupName = 'browser_table'

    propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
      index_name: indexName
      group_name: groupName

    parsedResponse = propertiesConfigModel.parse(sampleResponse2)
    comparatorsInFiltersGot = parsedResponse['comparators_for_text_filter_set']

    expect(_.isEqual(comparatorsInFilterMustBe, comparatorsInFiltersGot)).toBe(true)




