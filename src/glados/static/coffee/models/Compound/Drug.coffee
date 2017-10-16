glados.useNameSpace 'glados.models.Compound',
  Drug: Compound.extend {}

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
    'sort_disabled': true
    'is_sorting': 0
    'sort_class': 'fa-sort'



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
  ]
  RESULTS_LIST_REPORT_CARD_ADDITIONAL: [
    Drug.COLUMNS.USAN_STEM_DEFINITION
    Drug.COLUMNS.USAN_STEM_SUBSTEM
    Drug.COLUMNS.INDICATION_CLASS
  ]
  RESULTS_LIST_REPORT_CARD: [
    Drug.COLUMNS.CHEMBL_ID
    Drug.COLUMNS.SYNONYMS
    Drug.COLUMNS.RESEARCH_CODES
    Drug.COLUMNS.PHASE
  ]