glados.useNameSpace 'glados.models.visualisation',
  PropertiesFactory:
    Compound:
      esIndex:'chembl_molecule'
      Properties:
        CHEMBL_ID:
          propName:'molecule_chembl_id'
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
          coloursRange: [glados.Settings.VISUALISATION_LIGHT_BLUE_MIN, glados.Settings.VISUALISATION_LIGHT_BLUE_MAX]
          colourScaleType: glados.Visualisation.CONTINUOUS
          ticksNumber: 5
        PSA:
          propName:'molecule_properties.psa'
          label: 'Polar Surface Area'
        HBA:
          propName:'molecule_properties.hba'
          label: 'Hydrogen Bond Acceptors'
        HBD:
          propName:'molecule_properties.hbd'
          label: 'Hydrogen Bond Donnors'
    Activity:
      esIndex:'chembl_activity'
      Properties:
        LIGAND_EFFICIENCY_SEI:
          propName: 'ligand_efficiency.sei'
          label: 'Surface Efficieny index (SEI)'
          type: Number
        LIGAND_EFFICIENCY_BEI:
          propName: 'ligand_efficiency.bei'
          label: 'Binding Efficieny index (BEI)'
          type: Number
        STANDARD_VALUE:
          propName: 'standard_value'
          label: 'Standard Value nM'
          domain:[1, 100, 1000]
          coloursRange: [
            glados.Settings.VISUALISATION_GREEN_BASE
            glados.Settings.VISUALISATION_LIGHT_GREEN_BASE
            glados.Settings.VISUALISATION_AMBER_BASE
            glados.Settings.VISUALISATION_RED_BASE
          ]
          colourScaleType: glados.Visualisation.THRESHOLD
        MOLECULE_CHEMBL_ID:
          propName: 'molecule_chembl_id'
          label: 'Compound'
          type: String
        ACTIVITY_ID:
          propName: 'activity_id'
          label: 'Activity id'
        STANDARD_TYPE:
          propName: 'standard_type'
          label: 'Standard Type'
    CompoundTargetMatrix:
      Properties:
        PCHEMBL_VALUE_AVG:
          propName: 'pchembl_value_avg'
          label: 'PChEMBL Value Avg'
          type: Number
          coloursRange: [glados.Settings.VISUALISATION_LIGHT_GREEN_MIN, glados.Settings.VISUALISATION_LIGHT_GREEN_MAX]
          colourScaleType: glados.Visualisation.CONTINUOUS
          ticksNumber: 5
        PCHEMBL_VALUE_MAX:
          propName: 'pchembl_value_max'
          label: 'PChEMBL Value Max'
          type: Number
        ACTIVITY_COUNT:
          propName: 'activity_count'
          label: 'Activity Count'
          type: Number
          coloursRange: [glados.Settings.VISUALISATION_LIGHT_GREEN_MIN, glados.Settings.VISUALISATION_LIGHT_GREEN_MAX]
          colourScaleType: glados.Visualisation.CONTINUOUS
          ticksNumber: 5
        HIT_COUNT:
          propName: 'hit_count'
          label: 'Hit Count'
          type: Number

    # Generic functions
    generateColourScale: (prop) ->

      if prop.colourScaleType == glados.Visualisation.CATEGORICAL
        prop.colourScale = d3.scale.ordinal()
      else if prop.colourScaleType == glados.Visualisation.CONTINUOUS
        prop.colourScale = d3.scale.linear()
      else if prop.colourScaleType == glados.Visualisation.THRESHOLD
        prop.colourScale = d3.scale.threshold()
      prop.colourScale.domain(prop.domain).range(prop.coloursRange)

    generateContinuousDomainFromValues: (prop, values) ->

      minVal = Number.MAX_VALUE
      maxVal = -Number.MAX_VALUE

      for val in values

        val = parseFloat(val)
        if val == glados.Settings.DEFAULT_NULL_VALUE_LABEL or !val?
            continue

        if val > maxVal
          maxVal = val
        if val < minVal
          minVal = val

      prop.domain = [minVal, maxVal]

glados.models.visualisation.PropertiesFactory.getPropertyConfigFor = (entityName, propertyID, withColourScale=false) ->

  esIndex = glados.models.visualisation.PropertiesFactory[entityName].esIndex
  customConfig = glados.models.visualisation.PropertiesFactory[entityName].Properties[propertyID]
  baseConfig = if not esIndex? \
    then {} else glados.models.paginatedCollections.esSchema.GLaDOS_es_GeneratedSchema[esIndex][customConfig.propName]

  prop = $.extend({}, baseConfig, customConfig)

  if withColourScale
    glados.models.visualisation.PropertiesFactory.generateColourScale(prop)

  return prop
