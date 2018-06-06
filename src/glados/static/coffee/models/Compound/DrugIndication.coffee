glados.useNameSpace 'glados.models.Compound',
  DrugIndication: Backbone.Model.extend

    parse: (response) ->

      response.mesh_url = "https://id.nlm.nih.gov/mesh/#{response.mesh_id}.html"
      if not response.efo_id?
        response.efo_url = ''
      else
        response.efo_url = "http://www.ebi.ac.uk/efo/#{response.efo_id.replace(/:/g, '_')}"
      return response

glados.models.Compound.DrugIndication.COLUMNS =
  DRUG_IND_ID:
    name_to_show: 'ID'
    comparator: 'drugind_id'
  MESH_HEADING:
    name_to_show: 'MESH Heading'
    comparator: 'mesh_heading'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
  MESH_ID:
    name_to_show: 'MESH ID'
    comparator: 'mesh_id'
    link_base: 'mesh_url'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
  EFO_TERM:
    name_to_show: 'EFO Term'
    comparator: 'efo_term'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
  EFO_ID:
    name_to_show: 'EFO ID'
    comparator: 'efo_id'
    link_base: 'efo_url'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
  IND_MAX_PHASE:
    name_to_show: 'Max Phase'
    comparator: 'max_phase_for_ind'
    sort_disabled: false
    is_sorting: -1
    sort_class: 'fa-sort-desc'
  REFERENCES:
    name_to_show: 'References'
    comparator: 'indication_refs'
    multiple_links: true
    multiple_links_function: (refs) -> ({text:r.ref_type, url:r.ref_url} for r in refs)
  MOLECULE_CHEMBL_ID:
    name_to_show: 'ChEMBL ID'
    comparator: 'molecule_chembl_id'
    sort_disabled: false
    is_sorting: 0
    sort_class: 'fa-sort'
    link_function: (value) -> Compound.get_report_card_url(value)


glados.models.Compound.DrugIndication.ID_COLUMN = glados.models.Compound.DrugIndication.COLUMNS.DRUG_IND_ID

glados.models.Compound.DrugIndication.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.DrugIndication.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.DrugIndication.COLUMNS.MESH_HEADING
    glados.models.Compound.DrugIndication.COLUMNS.MESH_ID
    glados.models.Compound.DrugIndication.COLUMNS.EFO_TERM
    glados.models.Compound.DrugIndication.COLUMNS.EFO_ID
    glados.models.Compound.DrugIndication.COLUMNS.IND_MAX_PHASE
    glados.models.Compound.DrugIndication.COLUMNS.REFERENCES
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_CHEMBL_ID
  ]

