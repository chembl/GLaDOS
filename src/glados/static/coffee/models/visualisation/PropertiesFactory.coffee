glados.useNameSpace 'glados.models.visualisation',
  PropertiesFactory:
    Compound:
      esIndex:'chembl_molecule'
      Properties:
        CHEMBL_ID:
          propName:'molecule_chembl_id'
          type: 'string'
          label: 'CHEMBL_ID'
        ALogP:
          propName: 'molecule_properties.alogp'
          label: 'ALogP'
        RO5:
          propName:'molecule_properties.num_ro5_violations'
          label: '#RO5 Violations'
          domain: [glados.Settings.DEFAULT_NULL_VALUE_LABEL, 0, 1, 2, 3, 4]
          coloursRange: [glados.Settings.VISUALISATION_GREY_BASE, '#e3f2fd', '#90caf9', '#42a5f5', '#1976d2', '#0d47a1']
          colourScaleType: glados.Visualisation.CATEGORICAL
        FULL_MWT:
          propName:'molecule_properties.full_mwt'
          label: 'Parent Molecular Weight'
        PSA:
          propName:'molecule_properties.psa'
          type: 'number'
          label: 'Polar Surface Area'
        HBA:
          propName:'molecule_properties.hba'
          type: 'number'
          label: 'Hydrogen Bond Acceptors'
        HBD:
          propName:'molecule_properties.hbd'
          type: 'number'
          label: 'Hydrogen Bond Donnors'

glados.models.visualisation.PropertiesFactory.getPropertyConfigFor = (entityName, propertyID, withColourScale=false) ->

  esIndex = glados.models.visualisation.PropertiesFactory[entityName].esIndex
  customConfig = glados.models.visualisation.PropertiesFactory[entityName].Properties[propertyID]
  baseConfig = glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[esIndex][customConfig.propName]

  prop = $.extend({}, baseConfig, customConfig)

  if withColourScale
    if prop.colourScaleType == glados.Visualisation.CATEGORICAL
      prop.colourScale = d3.scale.ordinal()
      .domain(prop.domain)
      .range(prop.coloursRange)

  return prop
