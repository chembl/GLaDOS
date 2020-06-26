glados.useNameSpace 'glados.models.Compound',
  Drug: Compound.extend
    entityName: 'Drug'
    entityNamePlural: 'Drugs'
    browseLinkEntityName: 'Drug'
    parse: (response) ->

      objData = response._source
      patentID = objData._metadata.drug.drug_data.sc_patent
      if patentID
        response.patent_url = 'https://www.surechembl.org/document/' + patentID
      return Compound.prototype.parse.call(@, response)

Drug = glados.models.Compound.Drug

glados.models.Compound.Drug.PROPERTIES_VISUAL_CONFIG = {
  'drug_parent_molecule_chembl_id': Compound.PROPERTIES_VISUAL_CONFIG['molecule_chembl_id']
  'molecule_synonyms': {
    'custom_field_template': '<ul class="no-margin" style="margin-left: 1rem !important;">' +
      '{{#each val}}<li style="list-style-type: circle;">{{this}}</li>{{/each}}</ul>'
    'parse_function': (values) ->

      synonyms = {}
      for v in values
        if v.syn_type != 'OTHER' and v.syn_type != 'TRADE_NAME' and v.syn_type != 'RESEARCH_CODE'
          if not synonyms[v.molecule_synonym]?
            synonyms[v.molecule_synonym] = []
          synonyms[v.molecule_synonym].push v.syn_type

      values = []
      for key, types of synonyms
        values.push key + ' (' + types.join(', ') + ')'

      return values
  }
  'research_codes': {
    'parse_function': (values) -> (v.molecule_synonym for v in values when v.syn_type == "RESEARCH_CODE").join(', ')
  }
  'drug_atc_codes': {
    'parse_function': (values) ->
      if values == glados.Settings.DEFAULT_NULL_VALUE_LABEL
        return glados.Settings.DEFAULT_NULL_VALUE_LABEL
      else
        return (data['level5'] for data in values).join(', ')
  }
  'drug_atc_codes_level_4': {
    'parse_function': (values) ->
      if values == glados.Settings.DEFAULT_NULL_VALUE_LABEL
        return glados.Settings.DEFAULT_NULL_VALUE_LABEL
      else
        return (data['level4_description'] for data in values).join(', ')
  }
  'drug_atc_codes_level_3': {
    'parse_function': (values) ->
      if values == glados.Settings.DEFAULT_NULL_VALUE_LABEL
        return glados.Settings.DEFAULT_NULL_VALUE_LABEL
      else
        return (data['level3_description'] for data in values).join(', ')
  }
  'drug_atc_codes_level_2': {
    'parse_function': (values) ->
      if values == glados.Settings.DEFAULT_NULL_VALUE_LABEL
        return glados.Settings.DEFAULT_NULL_VALUE_LABEL
      else
        return (data['level2_description'] for data in values).join(', ')
  }
  'drug_atc_codes_level_1': {
    'parse_function': (values) ->
      if values == glados.Settings.DEFAULT_NULL_VALUE_LABEL
        return glados.Settings.DEFAULT_NULL_VALUE_LABEL
      else
        return (data['level1_description'] for data in values).join(', ')
  }
  'patent': {
    link_base: 'patent_url'
  }
  'drug_icon': {
    'sort_disabled': true
    'on_click': CompoundReportCardApp.initDrugIconGridFromFunctionLink
    'function_parameters': ['molecule_chembl_id']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    'function_key': 'drug_icon_grid'
    'function_link': true
    'execute_on_render': true
    'hide_value': true
    'remove_link_after_click': true
    'table_cell_width': '250px'
  }
}

glados.models.Compound.Drug.COLUMNS =
  CHEMBL_ID: _.extend({}, Compound.COLUMNS.CHEMBL_ID,
    'name_to_show': 'Parent Molecule')
  SYNONYMS: _.extend({}, Compound.COLUMNS.SYNONYMS,
    'custom_field_template': '<ul class="no-margin" style="margin-left: 1rem !important;">' +
      '{{#each val}}<li style="list-style-type: circle;">{{this}}</li>{{/each}}</ul>'
    'parse_function': (values) ->

      synonyms = {}
      for v in values
        if v.syn_type != 'OTHER' and v.syn_type != 'TRADE_NAME' and v.syn_type != 'RESEARCH_CODE'
          if not synonyms[v.molecule_synonym]?
            synonyms[v.molecule_synonym] = []
          synonyms[v.molecule_synonym].push v.syn_type

      values = []
      for key, types of synonyms
        values.push key + ' (' + types.join(', ') + ')'

      return values
  )
  RESEARCH_CODES: _.extend({}, Compound.COLUMNS.SYNONYMS,
    'name_to_show_short' : 'Research Codes'
    'name_to_show': 'Research Codes'
    'parse_function': (values) -> (v.molecule_synonym for v in values when v.syn_type == "RESEARCH_CODE").join(', ')
  )
  PHASE: _.extend({}, Compound.COLUMNS.MAX_PHASE,
    'name_to_show': 'Phase')
  APPLICANTS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'Applicants'
    comparator: '_metadata.drug.drug_data.applicants'
  USAN_STEM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'USAN Stem'
    comparator: 'usan_stem'
  USAN_YEAR: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'USAN Year'
    comparator: 'usan_year'
  FIRST_APPROVAL: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'First Approval'
    comparator: 'first_approval'
  ATC_CLASSIFICATIONS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'ATC Classifications'
    comparator: 'atc_classifications'
    parse_function: (values) -> values.join(', ')
  USAN_STEM_DEFINITION: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'USAN Stem Definition'
    comparator: 'usan_stem_definition'
  USAN_STEM_SUBSTEM: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'USAN Stem Substem'
    comparator: '_metadata.drug.drug_data.usan_stem_substem'
  INDICATION_CLASS: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'Indication Class'
    comparator: 'indication_class'
  PATENT: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'Patent'
    comparator: '_metadata.drug.drug_data.sc_patent'
    link_base: 'patent_url'
  WITHDRAWN_YEAR: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'Withdrawn Year'
    comparator: 'withdrawn_year'
  WITHDRAWN_COUNTRY: glados.models.paginatedCollections.ColumnsFactory.generateColumn Compound.INDEX_NAME,
    name_to_show: 'Withdrawn Country'
    comparator: 'withdrawn_country'


glados.models.Compound.Drug.COLUMNS.CHEMBL_ID = _.extend({}, Compound.COLUMNS.CHEMBL_ID, 'name_to_show': 'Parent Molecule')
glados.models.Compound.Drug.ID_COLUMN = glados.models.Compound.Drug.COLUMNS.CHEMBL_ID


Drug.getDrugsListURL = (filter, isFullState=false, fragmentOnly=false) ->

  if isFullState
    filter = btoa(JSON.stringify(filter))

  glados.Settings.ENTITY_BROWSERS_URL_GENERATOR
    fragment_only: fragmentOnly
    entity: 'drugs'
    filter: encodeURIComponent(filter) unless not filter?
    is_full_state: isFullState