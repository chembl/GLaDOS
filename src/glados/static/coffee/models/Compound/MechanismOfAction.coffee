glados.useNameSpace 'glados.models.Compound',
  MechanismOfAction: Backbone.Model.extend

    parse: (resp) ->
      imageFile = glados.Utils.getNestedValue(resp, 'parent_molecule._metadata.compound_generated.image_file')
      if imageFile != glados.Settings.DEFAULT_NULL_VALUE_LABEL
        resp.parent_image_url = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{imageFile}"
      else
        resp.parent_image_url = \
          "#{glados.Settings.WS_BASE_URL}image/#{resp.parent_molecule.molecule_chembl_id}.svg?engine=indigo"
      resp.molecule_link = Compound.get_report_card_url(resp.parent_molecule.molecule_chembl_id)

      resp.target_link = null
      if resp.target?
        resp.target_link = Target.get_report_card_url(resp.target.target_chembl_id)
      return resp


glados.models.Compound.MechanismOfAction.INDEX_NAME = 'chembl_mechanism_by_parent_target'

generateMechanismColumn = (columnMetadata)->
  return glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Compound\
    .MechanismOfAction.INDEX_NAME, columnMetadata

glados.models.Compound.MechanismOfAction.COLUMNS =
  MECH_ID: generateMechanismColumn
    comparator: 'mechanism_of_action.mec_id'
  MECHANISM_OF_ACTION: generateMechanismColumn
    comparator: 'mechanism_of_action.mechanism_of_action'
  ACTION_TYPE: generateMechanismColumn
    comparator: 'mechanism_of_action.action_type'
  MAX_PHASE: generateMechanismColumn
    comparator: 'mechanism_of_action.max_phase'
  TARGET_CHEMBL_ID: generateMechanismColumn
    comparator: 'target.target_chembl_id'
    link_base:'target_link'
  TARGET_PREF_NAME: generateMechanismColumn
    comparator: 'target.pref_name'
  REFERENCES: generateMechanismColumn
    comparator: 'mechanism_of_action.mechanism_refs'
    multiple_links: true
    multiple_links_function: (refs) -> ({text:r.ref_type, url:r.ref_url} for r in refs)
    sort_disabled: true
  COMPOUNDS: generateMechanismColumn
    comparator: 'mechanism_of_action._metadata.all_molecule_chembl_ids'
    multiple_links: true
    multiple_links_function: (ids) -> ({text:id, url:Compound.get_report_card_url(id)} for id in ids)
  MOLECULE_CHEMBL_ID: generateMechanismColumn
    comparator: 'parent_molecule.molecule_chembl_id'
    image_base_url: 'parent_image_url'
    link_base: 'molecule_link'
  MOLECULE_PREF_NAME: generateMechanismColumn
    comparator: 'parent_molecule.pref_name'
  MOLECULE_DRUG_SYNONYMS: generateMechanismColumn
    comparator: 'parent_molecule._metadata.drug.drug_data.synonyms'

glados.models.Compound.MechanismOfAction.ID_COLUMN = glados.models.Compound.MechanismOfAction.COLUMNS.MECH_ID

glados.models.Compound.MechanismOfAction.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.MechanismOfAction.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE_REPORT_CARD: [
    glados.models.Compound.MechanismOfAction.COLUMNS.MECHANISM_OF_ACTION
    glados.models.Compound.MechanismOfAction.COLUMNS.TARGET_CHEMBL_ID
    glados.models.Compound.MechanismOfAction.COLUMNS.REFERENCES
    glados.models.Compound.MechanismOfAction.COLUMNS.COMPOUNDS
  ]
  RESULTS_LIST_TABLE: [
    glados.models.Compound.MechanismOfAction.COLUMNS.MOLECULE_CHEMBL_ID
    glados.models.Compound.MechanismOfAction.COLUMNS.MOLECULE_PREF_NAME
    glados.models.Compound.MechanismOfAction.COLUMNS.MOLECULE_DRUG_SYNONYMS
    glados.models.Compound.MechanismOfAction.COLUMNS.COMPOUNDS
    glados.models.Compound.MechanismOfAction.COLUMNS.ACTION_TYPE
    glados.models.Compound.MechanismOfAction.COLUMNS.MECHANISM_OF_ACTION
    glados.models.Compound.MechanismOfAction.COLUMNS.TARGET_CHEMBL_ID
    glados.models.Compound.MechanismOfAction.COLUMNS.TARGET_PREF_NAME
    glados.models.Compound.MechanismOfAction.COLUMNS.MAX_PHASE
    glados.models.Compound.MechanismOfAction.COLUMNS.REFERENCES
  ]
  DOWNLOAD_COLUMNS: [
    glados.models.Compound.MechanismOfAction.COLUMNS.MOLECULE_CHEMBL_ID
    glados.models.Compound.MechanismOfAction.COLUMNS.ACTION_TYPE
    glados.models.Compound.MechanismOfAction.COLUMNS.MECHANISM_OF_ACTION
    glados.models.Compound.MechanismOfAction.COLUMNS.TARGET_CHEMBL_ID
    glados.models.Compound.MechanismOfAction.COLUMNS.MAX_PHASE
    glados.models.Compound.MechanismOfAction.COLUMNS.REFERENCES
  ]

glados.models.Compound.MechanismOfAction.getListURL = (filter) ->

  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    entity: 'mechanisms_of_action'
    filter: encodeURIComponent(filter) unless not filter?


glados.models.Compound.MechanismOfAction.getListURLByMoleculeChemblId = (moleculeChemblId) ->
  filterStr = "mechanism_of_action._metadata.all_molecule_chembl_ids:#{moleculeChemblId}"
  glados.models.Compound.MechanismOfAction.getListURL filterStr