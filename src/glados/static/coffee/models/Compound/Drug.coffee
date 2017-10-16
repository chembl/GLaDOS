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
        if v.syn_type != "OTHER" and v.syn_type != "TRADE_NAME" and v.syn_type != "RESEARCH_CODE"
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
  ]
  RESULTS_LIST_REPORT_CARD_ADDITIONAL: []
  RESULTS_LIST_REPORT_CARD: [
    Drug.COLUMNS.CHEMBL_ID
    Drug.COLUMNS.SYNONYMS
    Drug.COLUMNS.RESEARCH_CODES
    Drug.COLUMNS.PHASE
  ]