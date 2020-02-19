glados.useNameSpace 'glados.models.Compound',
  DrugIndication: Backbone.Model.extend

    entityName: 'Drug Indication'
    entityNamePlural: 'Drug Indications'
    idAttribute:'drug_indication.drugind_id'

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
          "#{glados.Settings.WS_BASE_URL}image/#{objData.parent_molecule.molecule_chembl_id}.svg?engine=indigo"
      objData.molecule_link = Compound.get_report_card_url(objData.parent_molecule.molecule_chembl_id)


      objData.mesh_url = "https://id.nlm.nih.gov/mesh/#{objData.drug_indication.mesh_id}.html"
      return objData

glados.models.Compound.DrugIndication.INDEX_NAME = glados.Settings.CHEMBL_ES_INDEX_PREFIX+'drug_indication_by_parent'
glados.models.Compound.DrugIndication.PROPERTIES_VISUAL_CONFIG = {
  'parent_molecule.molecule_chembl_id': {
    image_base_url: 'parent_image_url'
    link_base: 'molecule_link'
  }
  'drug_indication.mesh_id': {
    link_base: 'mesh_url'
  }
  'efo_ids': {
    comparator: 'drug_indication.efo'
    multiple_links: true
    multiple_links_function: (efos) ->
      ({text:efo.id, url:"http://www.ebi.ac.uk/efo/#{efo.id.replace(/:/g, '_')}"} for efo in efos)
  }
  'efo_terms': {
    parse_function: (values) ->
      realValues = []
      for valI in values
        if valI?.term?.trim().length > 0
          realValues.push valI.term.trim()
      return realValues.join(', ')
  }
  'drug_indication.indication_refs': {
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

}

generateDrugIndicationColumn = (columnMetadata)->
  return glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Compound\
    .DrugIndication.INDEX_NAME, columnMetadata

glados.models.Compound.DrugIndication.COLUMNS =
  DRUGIND_ID: generateDrugIndicationColumn
    comparator: 'drug_indication.drugind_id'
  MESH_ID: generateDrugIndicationColumn
    comparator: 'drug_indication.mesh_id'
    link_base: 'mesh_url'
  MESH_HEADING: generateDrugIndicationColumn
    comparator: 'drug_indication.mesh_heading'
  EFO_ID: generateDrugIndicationColumn
    name_to_show: 'EFO ID'
    name_to_show_short: 'EFO ID'
    comparator: 'drug_indication.efo'
    multiple_links: true
    multiple_links_function: (efos) ->
      ({text:efo.id, url:"http://www.ebi.ac.uk/efo/#{efo.id.replace(/:/g, '_')}"} for efo in efos)
  EFO_TERM: _.extend(
    {}, generateDrugIndicationColumn({comparator: 'drug_indication.efo'}),
      name_to_show: 'EFO Term'
      name_to_show_short: 'EFO Term'
      parse_function: (values) ->
        realValues = []
        for valI in values
          if valI?.term?.trim().length > 0
            realValues.push valI.term.trim()
        return realValues.join(', ')
  )
  INDICATION_MAX_PHASE: generateDrugIndicationColumn
    comparator: 'drug_indication.max_phase_for_ind'

  INDICATION_REFERENCES:generateDrugIndicationColumn
    comparator: 'drug_indication.indication_refs'
    multiple_links: true
    multiple_links_function: (refs) -> ({text:r.ref_type, url:r.ref_url} for r in refs)
  MOLECULE_CHEMBL_ID: generateDrugIndicationColumn
    comparator: 'parent_molecule.molecule_chembl_id'
    image_base_url: 'parent_image_url'
    link_base: 'molecule_link'
  MOLECULE_PREF_NAME: generateDrugIndicationColumn
    comparator: 'parent_molecule.pref_name'
  MOLECULE_TYPE: generateDrugIndicationColumn
    comparator: 'parent_molecule.molecule_type'
  MOLECULE_FIRST_APPROVAL: generateDrugIndicationColumn
    comparator: 'parent_molecule.first_approval'
  MOLECULE_USAN_STEM: generateDrugIndicationColumn
    comparator: 'parent_molecule.usan_stem'
  MOLECULE_USAN_YEAR: generateDrugIndicationColumn
    comparator: 'parent_molecule.usan_year'
  MOLECULE_DRUG_SYNONYMS: _.extend(
    {}, generateDrugIndicationColumn({comparator: 'parent_molecule._metadata.drug.drug_data.synonyms'}),
      custom_field_template: '<ul class="no-margin" style="width: 15rem; margin-left: 1rem !important;">' +
        '{{#each val}}<li style="list-style-type: circle;">{{this}}</li>{{/each}}</ul>'
      parse_function: (values) ->
        realValues = []
        for valI in values
          if valI?.trim().length > 0
            realValues.push valI.trim()
        return realValues
  )


glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_CHEMBL_ID = {
  aggregatable: true
  comparator: "parent_molecule.molecule_chembl_id"
  id: "parent_molecule.molecule_chembl_id"
  image_base_url: "parent_image_url"
  is_sorting: 0
  link_base: "molecule_link"
  name_to_show: "ChEMBL ID"
  name_to_show_short: "ChEMBL ID"
  show: true
  sort_class: "fa-sort"
  sort_disabled: false
}

glados.models.Compound.DrugIndication.ID_COLUMN = glados.models.Compound.DrugIndication.COLUMNS.DRUGIND_ID

glados.models.Compound.DrugIndication.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.DrugIndication.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_CHEMBL_ID
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_PREF_NAME
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_TYPE
    glados.models.Compound.DrugIndication.COLUMNS.INDICATION_MAX_PHASE
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_FIRST_APPROVAL
    glados.models.Compound.DrugIndication.COLUMNS.MESH_ID
    glados.models.Compound.DrugIndication.COLUMNS.MESH_HEADING
    glados.models.Compound.DrugIndication.COLUMNS.EFO_ID
    glados.models.Compound.DrugIndication.COLUMNS.EFO_TERM
    glados.models.Compound.DrugIndication.COLUMNS.INDICATION_REFERENCES
  ]
  RESULTS_LIST_TABLE_ADDITIONAL: [
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_DRUG_SYNONYMS
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_USAN_STEM
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_USAN_YEAR
  ]

glados.models.Compound.DrugIndication.getListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'drug_indications'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState

glados.models.Compound.DrugIndication.getListURLByMoleculeChemblId = (moleculeChemblId) ->
  filterStr = "drug_indication._metadata.all_molecule_chembl_ids:#{moleculeChemblId}"
  glados.models.Compound.DrugIndication.getListURL filterStr

glados.models.Compound.DrugIndication.COLUMNS_SETTINGS.DOWNLOAD_COLUMNS =
  _.union(glados.models.Compound.DrugIndication.COLUMNS_SETTINGS.RESULTS_LIST_TABLE,
    glados.models.Compound.DrugIndication.COLUMNS_SETTINGS.RESULTS_LIST_TABLE_ADDITIONAL)