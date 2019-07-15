describe 'PropertiesConfigurationModel', ->
  sampleResponse = {
    "properties": {
      "optional": [
        {
          "type": "string",
          "label": "Name",
          "aggregatable": true,
          "index_name": "chembl_molecule",
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
          "index_name": "chembl_molecule",
          "sortable": true,
          "label_mini": "ChEMBL ID",
          "prop_id": "molecule_chembl_id"
        }
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
        "index_name": "chembl_molecule",
        "sortable": true,
        "label_mini": "Name",
        "prop_id": "pref_name",
        "sort_disabled": false,
        "is_sorting": 0,
        "sort_class": "fa-sort",
        "name_to_show": "Name",
        "name_to_show_short": "Name",
        "id": "pref_name"
      }
    ],
    "Default": [
      {
        "show": true,
        "type": "string",
        "label": "ChEMBL ID",
        "aggregatable": true,
        "index_name": "chembl_molecule",
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
    indexName = 'chembl_molecule'
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
    indexName = 'chembl_molecule'
    groupName = 'browser_table'

    propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
      index_name: indexName
      group_name: groupName

    propertiesConfigModel.parse(sampleResponse)
    parsedConfigGot = propertiesConfigModel.get('parsed_configuration')

    expect(_.isEqual(parsedConfigGot, parsedConfigMustBe)).toBe(true)



