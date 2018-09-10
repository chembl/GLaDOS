glados.useNameSpace 'glados.models.Compound',
  MechanismOfAction: Backbone.Model.extend

    parse: (response) ->

      response.target_link = Target.get_report_card_url(response.target_chembl_id)
      return response

glados.models.Compound.MechanismOfAction.COLUMNS =
  MECH_ID:
    name_to_show: 'ID'
    comparator: 'mec_id'
  MECHANISM_OF_ACTION:
    name_to_show: 'Mechanism Of Action'
    comparator: 'mechanism_of_action'
    sort_disabled: false
    is_sorting: -1
    sort_class: 'fa-sort-desc'
  ACTION_TYPE:
    name_to_show: 'Action Type'
    comparator: 'action_type'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
  MAX_PHASE:
    name_to_show: 'Phase'
    comparator: 'max_phase'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
  TARGET_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_chembl_id'
    link_base:'target_link'
  REFERENCES:
    name_to_show: 'References'
    comparator: 'mechanism_refs'
    multiple_links: true
    multiple_links_function: (refs) -> ({text:r.ref_type, url:r.ref_url} for r in refs)
    sort_disabled: true
  COMPOUNDS:
    name_to_show: 'Compounds'
    comparator: 'molecule_chembl_ids'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
    multiple_links: true
    multiple_links_function: (ids) -> ({text:id, url:Compound.get_report_card_url(id)} for id in ids)
  MOLECULE_CHEMBL_ID:
    name_to_show: 'Mechanism Of Action'
    comparator: 'molecule_chembl_id'
    link_base: 'molecule_link'

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
    glados.models.Compound.MechanismOfAction.COLUMNS.ACTION_TYPE
    glados.models.Compound.MechanismOfAction.COLUMNS.MECHANISM_OF_ACTION
    glados.models.Compound.MechanismOfAction.COLUMNS.TARGET_CHEMBL_ID
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