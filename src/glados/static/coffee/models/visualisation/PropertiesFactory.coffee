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
          domain: [glados.Settings.DEFAULT_NULL_VALUE_LABEL, 0, 1, 2, 3, 4]
          coloursRange: [glados.Settings.VISUALISATION_GREY_BASE, '#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']
        FULL_MWT:
          prop_name:'molecule_properties.full_mwt'
          label: 'Parent Molecular Weight'

glados.models.visualisation.PropertiesFactory.getPropertyConfigFor = (entityName, propertyID) ->

  esIndex = glados.models.visualisation.PropertiesFactory[entityName].esIndex
  customConfig = glados.models.visualisation.PropertiesFactory[entityName].Properties[propertyID]
  baseConfig = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[esIndex][customConfig.propName]

  return $.extend({}, baseConfig, customConfig)


