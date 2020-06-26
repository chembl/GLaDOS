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
          "#{glados.Settings.WS_BASE_URL}image/#{objData.parent_molecule.molecule_chembl_id}.svg"
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

glados.models.Compound.DrugIndication.COLUMNS =

  MOLECULE_CHEMBL_ID:

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


  DRUGIND_ID:

    aggregatable: true
    comparator: "drug_indication.drugind_id"
    id: "drug_indication.drugind_id"
    is_sorting: 0
    name_to_show: "Drug Indication Drugind ID"
    name_to_show_short: "Drug Indc. Drgn. ID"
    prop_id: "drug_indication.drugind_id"
    show: true
    sort_class: "fa-sort"
    sort_disabled: false

glados.models.Compound.DrugIndication.ID_COLUMN = glados.models.Compound.DrugIndication.COLUMNS.DRUGIND_ID

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
