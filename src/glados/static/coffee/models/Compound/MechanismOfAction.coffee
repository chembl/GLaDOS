glados.useNameSpace 'glados.models.Compound',
  MechanismOfAction: Backbone.Model.extend

    entityName: 'Drug Mechanisms'
    entityNamePlural: 'Drug Mechanisms'
    idAttribute:'mechanism_of_action.mec_id'

    parse: (response) ->

      if response._source?
        objData = response._source
      else
        objData = response

      imageFile = glados.Utils.getNestedValue(objData, 'parent_molecule._metadata.compound_generated.image_file')
      if imageFile != glados.Settings.DEFAULT_NULL_VALUE_LABEL
        objData.parent_image_url = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{imageFile}"
      else
        objData.parent_image_url = \
          "#{glados.Settings.WS_BASE_URL}image/#{objData.parent_molecule.molecule_chembl_id}.svg"
      objData.molecule_link = Compound.get_report_card_url(objData.parent_molecule.molecule_chembl_id)

      objData.target_link = null
      if objData.target?
        objData.target_link = Target.get_report_card_url(objData.target.target_chembl_id)
      return objData


glados.models.Compound.MechanismOfAction.INDEX_NAME = 'chembl_mechanism_by_parent_target'
glados.models.Compound.MechanismOfAction.PROPERTIES_VISUAL_CONFIG = {
  'parent_molecule.molecule_chembl_id': {
    image_base_url: 'parent_image_url'
    link_base: 'molecule_link'
  }
  'target.target_chembl_id': {
    link_base:'target_link'
  }
  'mechanism_of_action.mechanism_refs': {
    multiple_links: true
    multiple_links_function: (refs) -> ({text:r.ref_type, url:r.ref_url} for r in refs)
  }
  'parent_molecule._metadata.drug.drug_data.synonyms': {
    custom_field_template: '<ul class="no-margin" style="width: 15rem; margin-left: 1rem !important;">' +
        '{{#each val}}<li style="list-style-type: circle;">{{this}}</li>{{/each}}</ul>'
    parse_function: (values) ->
      realValues = []
      for valI in values
        if valI?.trim().length > 0
          realValues.push valI.trim()
      return realValues
  }
  'drug_atc_codes': glados.models.Compound.Drug.PROPERTIES_VISUAL_CONFIG['drug_atc_codes']
  'drug_atc_codes_level_4': glados.models.Compound.Drug.PROPERTIES_VISUAL_CONFIG['drug_atc_codes_level_4']
  'drug_atc_codes_level_3': glados.models.Compound.Drug.PROPERTIES_VISUAL_CONFIG['drug_atc_codes_level_3']
  'drug_atc_codes_level_2': glados.models.Compound.Drug.PROPERTIES_VISUAL_CONFIG['drug_atc_codes_level_2']
  'drug_atc_codes_level_1': glados.models.Compound.Drug.PROPERTIES_VISUAL_CONFIG['drug_atc_codes_level_1']
}

glados.models.Compound.MechanismOfAction.COLUMNS =

  MECH_ID:

    aggregatable: true
    comparator: "mechanism_of_action.mec_id"
    id: "mechanism_of_action.mec_id"
    is_sorting: 0
    name_to_show: "Mechanism ID"
    name_to_show_short: "Mech ID"
    show: true
    sort_class: "fa-sort"
    sort_disabled: false


glados.models.Compound.MechanismOfAction.ID_COLUMN = glados.models.Compound.MechanismOfAction.COLUMNS.MECH_ID

glados.models.Compound.MechanismOfAction.getListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'mechanisms_of_action'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState

glados.models.Compound.MechanismOfAction.getListURLByMoleculeChemblId = (moleculeChemblId) ->
  filterStr = "mechanism_of_action._metadata.all_molecule_chembl_ids:#{moleculeChemblId}"
  glados.models.Compound.MechanismOfAction.getListURL filterStr

glados.models.Compound.MechanismOfAction.getListURLByTargetChemblId = (moleculeChemblId) ->
  filterStr = "target.target_chembl_id:#{moleculeChemblId}"
  glados.models.Compound.MechanismOfAction.getListURL filterStr
