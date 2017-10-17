glados.useNameSpace 'glados.models.Compound',
  Drug: Compound.extend
    parse: (response) ->
      patentID = response._metadata.drug.drug_data.sc_patent
      if patentID
        response.patent_url = 'https://www.surechembl.org/document/' + patentID
      return Compound.prototype.parse.call(@, response)

Drug = glados.models.Compound.Drug

glados.models.Compound.Drug.COLUMNS =
  CHEMBL_ID: _.extend({}, Compound.COLUMNS.CHEMBL_ID,
    'name_to_show': 'Parent Molecule')
  SYNONYMS: _.extend({}, Compound.COLUMNS.SYNONYMS,
    'parse_function': (values) ->

      synonyms = {}
      for v in values
        if v.syn_type != 'OTHER' and v.syn_type != 'TRADE_NAME' and v.syn_type != 'RESEARCH_CODE'
          if not synonyms[v.molecule_synonym]?
            synonyms[v.molecule_synonym] = []
          synonyms[v.molecule_synonym].push v.syn_type

      text = ""
      for key, types of synonyms
        text += key + '(' + types.join(', ') + ')'

      return text
  )
  RESEARCH_CODES: _.extend({}, Compound.COLUMNS.SYNONYMS,
    'name_to_show': 'Research Codes'
    'parse_function': (values) -> (v.molecule_synonym for v in values when v.syn_type == "RESEARCH_CODE").join(', ')
  )
  PHASE: _.extend({}, Compound.COLUMNS.MAX_PHASE,
    'name_to_show': 'Phase')
  APPLICANTS:
    'name_to_show': 'Applicants'
    'comparator': '_metadata.drug.drug_data.applicants'
    'sort_disabled': true
  USAN_STEM:
    'name_to_show': 'USAN Stem'
    'comparator': 'usan_stem'
    'is_sorting': 0
    'sort_class': 'fa-sort'
  USAN_YEAR:
    'name_to_show': 'USAN Year'
    'comparator': 'usan_year'
    'is_sorting': 0
    'sort_class': 'fa-sort'
  FIRST_APPROVAL:
    'name_to_show': 'First Approval'
    'comparator': 'first_approval'
    'is_sorting': 0
    'sort_class': 'fa-sort'
  ATC_CLASSIFICATIONS:
    'name_to_show': 'ATC Classifications'
    'comparator': 'atc_classifications'
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'parse_function': (values) -> values.join(', ')
  USAN_STEM_DEFINITION:
    'name_to_show': 'USAN Stem Definition'
    'comparator': 'usan_stem_definition'
    'sort_disabled': true
  USAN_STEM_SUBSTEM:
    'name_to_show': 'USAN Stem Substem'
    'comparator': '_metadata.drug.drug_data.usan_stem_substem'
    'sort_disabled': true
  INDICATION_CLASS:
    'name_to_show': 'Indication Class'
    'comparator': 'indication_class'
    'is_sorting': 0
    'sort_class': 'fa-sort'
  PATENT:
    'name_to_show': 'Patent'
    'comparator': '_metadata.drug.drug_data.sc_patent'
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base': 'patent_url'
    'secondary_link': true
  WITHDRAWN_YEAR:
    'name_to_show': 'Withdrawn Year'
    'comparator': 'withdrawn_year'
    'is_sorting': 0
    'sort_class': 'fa-sort'
  WITHDRAWN_COUNTRY:
    'name_to_show': 'Withdrawn Country'
    'comparator': 'withdrawn_country'
    'is_sorting': 0
    'sort_class': 'fa-sort'
  WITHDRAWN_REASON:
    'name_to_show': 'Withdrawn Reason'
    'comparator': 'withdrawn_reason'
    'sort_disabled': true
  ICON: {
    'name_to_show': 'Icon'
    'comparator': ''
    'sort_disabled': true
    'on_click': CompoundReportCardApp.initDrugIconGridFromFunctionLink
    'function_parameters': ['molecule_chembl_id']
    # to help bind the link to the function, it could be necessary to always use the key of the columns descriptions
    # or probably not, depending on how this evolves
    'function_key': 'drug_icon_grid'
    'function_link': true
    'execute_on_render': true
    'format_class': 'number-cell-center'
    'secondary_link': true
  }

glados.models.Compound.Drug.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of Drug.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    Drug.COLUMNS.CHEMBL_ID
    Drug.COLUMNS.SYNONYMS
    Drug.COLUMNS.RESEARCH_CODES
    Drug.COLUMNS.PHASE
    Drug.COLUMNS.APPLICANTS
    Drug.COLUMNS.USAN_STEM
    Drug.COLUMNS.USAN_YEAR
    Drug.COLUMNS.FIRST_APPROVAL
    Drug.COLUMNS.ATC_CLASSIFICATIONS
    Drug.COLUMNS.ICON
  ]
  RESULTS_LIST_REPORT_CARD_ADDITIONAL: [
    Drug.COLUMNS.USAN_STEM_DEFINITION
    Drug.COLUMNS.USAN_STEM_SUBSTEM
    Drug.COLUMNS.INDICATION_CLASS
    Drug.COLUMNS.PATENT
    Drug.COLUMNS.WITHDRAWN_YEAR
    Drug.COLUMNS.WITHDRAWN_REASON
    Drug.COLUMNS.WITHDRAWN_COUNTRY
  ]
  RESULTS_LIST_REPORT_CARD: [
    Drug.COLUMNS.CHEMBL_ID
    Drug.COLUMNS.SYNONYMS
    Drug.COLUMNS.RESEARCH_CODES
    Drug.COLUMNS.PHASE
  ]