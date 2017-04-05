glados.useNameSpace 'glados.models.visualisation',
  PropertiesFactory:
    Compound:
      esIndex:'chembl_molecule'
      Properties:
        ALogP:
          propName: 'molecule_properties.alogp'
          label: 'ALogP'

glados.models.visualisation.PropertiesFactory.getPropertyConfigFor = (entityName, propertyID) ->

  esIndex = glados.models.visualisation.PropertiesFactory[entityName].esIndex
  customConfig = glados.models.visualisation.PropertiesFactory[entityName].Properties[propertyID]
  baseConfig = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[esIndex][customConfig.propName]

  return $.extend({}, baseConfig, customConfig)


