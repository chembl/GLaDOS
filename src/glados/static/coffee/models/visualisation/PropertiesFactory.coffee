glados.useNameSpace 'glados.models.visualisation',
  PropertiesFactory:
    Compound:
      esIndex:'chembl_molecule'
      Properties:
        ALogP:
          propName: 'molecule_properties.alogp'
          label: 'ALogP'
        RO5:
          propName:'molecule_properties.num_ro5_violations'
          label: '#RO5 Violations'
          domain: [0, 4]
          tickValues: [0, 1, 2, 3, 4]
        FULL_MWT:
          prop_name:'molecule_properties.full_mwt'
          label: 'Parent Molecular Weight'

glados.models.visualisation.PropertiesFactory.getPropertyConfigFor = (entityName, propertyID) ->

  esIndex = glados.models.visualisation.PropertiesFactory[entityName].esIndex
  customConfig = glados.models.visualisation.PropertiesFactory[entityName].Properties[propertyID]
  baseConfig = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[esIndex][customConfig.propName]

  return $.extend({}, baseConfig, customConfig)


