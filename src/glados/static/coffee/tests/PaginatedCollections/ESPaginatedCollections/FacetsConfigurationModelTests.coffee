describe 'FacetsConfigurationModel', ->
  sampleResponse = {
    "properties": {
      "default": [
        {
          "agg_config": {
            "agg_params": {
              "initial_intervals": 20,
              "initial_sort": "asc",
              "report_card_entity": 'Compound'
            },
            "agg_type": "terms"
          },
          "prop_id": "_metadata.atc_classifications.level1_description",
          "property_config": {
            "aggregatable": true,
            "index_name": "chembl_molecule",
            "label": "ATC Classifications Level1 Description",
            "label_mini": "ATC Clsf. Levl. Desc.",
            "prop_id": "_metadata.atc_classifications.level1_description",
            "sortable": true,
            "type": "string"
          }
        },

        {
          "agg_config": {
            "agg_params": {

            },
            "agg_type": "terms"
          },
          "prop_id": "_metadata.related_activities.count",
          "property_config": {
            "aggregatable": true,
            "index_name": "chembl_molecule",
            "label": "Bioactivities",
            "label_mini": "Activities",
            "prop_id": "_metadata.related_activities.count",
            "sortable": true,
            "type": "integer"
          }
        }
      ]
      "optional": [
        {
          "agg_config": {
            "agg_params": {

            },
            "agg_type": "terms"
          },
          "prop_id": "_metadata.compound_generated.availability_type_label",
          "property_config": {
            "aggregatable": true,
            "index_name": "chembl_molecule",
            "label": "Availability Type",
            "label_mini": "Avlb. Type Labl.",
            "prop_id": "_metadata.compound_generated.availability_type_label",
            "sortable": true,
            "type": "string"
          }
        }
      ]
    }
  }

  propertiesConfigMustBe = {
    "_metadata.atc_classifications.level1_description": {
      "label": "ATC Classifications Level1 Description",
      "label_mini": "ATC Clsf. Levl. Desc.",
      "show": true,
      "position": 1,
      "es_index": "chembl_molecule",
      "prop_name": "_metadata.atc_classifications.level1_description",
      "initial_sort": "asc",
      "initial_intervals": 20,
      "prop_id": "_metadata.atc_classifications.level1_description"
      "report_card_entity": Compound
    },
    "_metadata.related_activities.count": {
      "label": "Bioactivities",
      "label_mini": "Activities",
      "show": true,
      "position": 2,
      "es_index": "chembl_molecule",
      "prop_name": "_metadata.related_activities.count",
      "initial_sort": null,
      "initial_intervals": null,
      "prop_id": "_metadata.related_activities.count"
      "report_card_entity": null
    },
    "_metadata.compound_generated.availability_type_label": {
      "label": "Availability Type",
      "label_mini": "Avlb. Type Labl.",
      "show": false,
      "position": 3,
      "es_index": "chembl_molecule",
      "prop_name": "_metadata.compound_generated.availability_type_label",
      "initial_sort": null,
      "initial_intervals": null,
      "prop_id": "_metadata.compound_generated.availability_type_label"
      "report_card_entity": null
    }
  }

  it 'Generates the correct url', ->
    indexName = 'chembl_molecule'
    groupName = 'browser_facets'

    facetsConfigModel = new glados.models.paginatedCollections.esSchema.FacetsConfigurationModel
      index_name: indexName
      group_name: groupName

    urlMustBe = glados.Settings.FACETS_GROUP_CONFIGURATION_URL_GENERATOR
      index_name: indexName
      group_name: groupName

    urlGot = facetsConfigModel.url
    expect(urlMustBe).toBe(urlGot)


  it 'Parses the response correctly', ->

    indexName = 'chembl_molecule'
    groupName = 'browser_table'

    facetsConfigModel = new glados.models.paginatedCollections.esSchema.FacetsConfigurationModel
      index_name: indexName
      group_name: groupName

    facetsConfigGot = facetsConfigModel.parse(sampleResponse)
    expect(_.isEqual(propertiesConfigMustBe, facetsConfigGot)).toBe(true)

