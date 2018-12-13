glados.useNameSpace 'glados.models.Compound',
  DrugIndication: Backbone.Model.extend

    parse: (resp) ->
      imageFile = glados.Utils.getNestedValue(resp, 'parent_molecule._metadata.compound_generated.image_file')
      if imageFile != glados.Settings.DEFAULT_NULL_VALUE_LABEL
        resp.parent_image_url = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{imageFile}"
      else
        resp.parent_image_url = \
          "#{glados.Settings.WS_BASE_URL}image/#{resp.parent_molecule.molecule_chembl_id}.svg?engine=indigo"
      resp.molecule_link = Compound.get_report_card_url(resp.parent_molecule.molecule_chembl_id)


      resp.mesh_url = "https://id.nlm.nih.gov/mesh/#{resp.mesh_id}.html"
      if not resp.efo_id?
        resp.efo_url = ''
      else
        resp.efo_url = "http://www.ebi.ac.uk/efo/#{resp.efo_id.replace(/:/g, '_')}"
      return resp

glados.models.Compound.DrugIndication.INDEX_NAME = 'chembl_mechanism_by_parent_target'

generateDrugIndicationColumn = (columnMetadata)->
  return glados.models.paginatedCollections.ColumnsFactory.generateColumn glados.models.Compound\
    .DrugIndication.INDEX_NAME, columnMetadata

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
#  IND_MAX_PHASE:
#    name_to_show: 'Max Phase'
#    comparator: 'max_phase_for_ind'
#    sort_disabled: false
#    is_sorting: -1
#    sort_class: 'fa-sort-desc'
  REFERENCES:
    name_to_show: 'References'
    comparator: 'indication_refs'
    sort_disabled: true
    multiple_links: true
    multiple_links_function: (refs) -> ({text:r.ref_type, url:r.ref_url} for r in refs)
  MOLECULE_CHEMBL_ID: generateDrugIndicationColumn
    comparator: 'parent_molecule.molecule_chembl_id'
    image_base_url: 'parent_image_url'
    link_base: 'molecule_link'
  MOLECULE_ATC_CODES: generateDrugIndicationColumn
    name_to_show: 'ATC Classifications'
    name_to_show_short: 'ATC Class.'
    comparator: 'parent_molecule._metadata.atc_classifications'
    parse_function: (atcClassifications) ->
      codes = new Set()
      for atcClassI in atcClassifications
        if atcClassI.level4? and atcClassI.level4.length > 0
          codes.add(atcClassI.level4)
      return Array.from(codes).join(', ')
  MOLECULE_ATC_CODES_DESCRIPTION: generateDrugIndicationColumn
    name_to_show: 'ATC Classifications Description'
    name_to_show_short: 'ATC Class. Desc.'
    comparator: 'parent_molecule._metadata.atc_classifications'
    custom_field_template: '<ul class="no-margin" style="width: 15rem; margin-left: 1rem !important;">' +
      '{{#each val}}<li style="list-style-type: circle;">{{this}}</li>{{/each}}</ul>'
    parse_function: (atcClassifications) ->
      codes = new Set()
      for atcClassI in atcClassifications
        if atcClassI.level4_description? and atcClassI.level4_description.length > 0
          codes.add(atcClassI.level4_description)
      return Array.from(codes)
  MOLECULE_FIRST_APPROVAL: generateDrugIndicationColumn
    comparator: 'parent_molecule.first_approval'
  MOLECULE_USAN_STEM: generateDrugIndicationColumn
    comparator: 'parent_molecule.usan_stem'
  MOLECULE_TYPE: generateDrugIndicationColumn
    comparator: 'parent_molecule.molecule_type'
  MOLECULE_PREF_NAME: generateDrugIndicationColumn
    comparator: 'parent_molecule.pref_name'
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


glados.models.Compound.DrugIndication.ID_COLUMN = glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_CHEMBL_ID

glados.models.Compound.DrugIndication.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.DrugIndication.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE_REPORT_CARD: [
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_CHEMBL_ID
#    glados.models.Compound.DrugIndication.COLUMNS.MESH_HEADING
#    glados.models.Compound.DrugIndication.COLUMNS.MESH_ID
#    glados.models.Compound.DrugIndication.COLUMNS.EFO_TERM
#    glados.models.Compound.DrugIndication.COLUMNS.EFO_ID
##    glados.models.Compound.DrugIndication.COLUMNS.IND_MAX_PHASE
#    glados.models.Compound.DrugIndication.COLUMNS.REFERENCES
  ]
  DOWNLOAD_COLUMNS: [
#    glados.models.Compound.DrugIndication.COLUMNS.MESH_HEADING
#    glados.models.Compound.DrugIndication.COLUMNS.MESH_ID
#    glados.models.Compound.DrugIndication.COLUMNS.EFO_TERM
#    glados.models.Compound.DrugIndication.COLUMNS.EFO_ID
#    glados.models.Compound.DrugIndication.COLUMNS.IND_MAX_PHASE
#    glados.models.Compound.DrugIndication.COLUMNS.REFERENCES
    glados.models.Compound.DrugIndication.COLUMNS.MOLECULE_CHEMBL_ID
  ]

glados.models.Compound.DrugIndication.getListURL = (filter) ->
  
  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    entity: 'drug_indications'
    filter: encodeURIComponent(filter) unless not filter?

#totalStr = ''
#for key, column of glados.models.Compound.MechanismOfAction.COLUMNS
#  totalStr += "msgid \"#{column.label_id}\"\n"
#  totalStr += "msgstr \"#{column.name_to_show}\"\n\n"
#  totalStr += "msgid \"#{column.label_mini_id}\"\n"
#  totalStr += "msgstr \"#{column.name_to_show_short}\"\n\n"
#
#console.error(totalStr)