glados.useNameSpace 'glados.models.paginatedCollections'
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search specific configuration settings
  # --------------------------------------------------------------------------------------------------------------------
  Settings:
    ES_BASE_URL: 'http://localhost:9200'
    ES_INDEXES:
      COMPOUND:
        PATH: '/chembl_molecule'
        MODEL: Compound
        COLUMNS: [
          {
            'name_to_show': 'ChEMBL ID'
            'comparator': 'molecule_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/compound_report_card/$$$'
            'image_base_url': Settings.WS_BASE_URL + 'image/$$$.svg'
          }
          {
            'name_to_show': 'Molecule Type'
            'comparator': 'molecule_type'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Name'
            'comparator': 'pref_name'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Max Phase'
            'comparator': 'max_phase'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Dosed Ingredient:'
            'comparator': 'dosed_ingredient'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
        ]
      DOCUMENT:
        PATH:'/chembl_document'
        MODEL: Document
        COLUMNS: [
          {
            'name_to_show': 'CHEMBL_ID'
            'comparator': 'document_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/document_report_card/$$$'
          }
          {
            'name_to_show': 'Title'
            'comparator': 'title'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'custom_field_template': '<i>{{val}}</i>'
          }
          {
            'name_to_show': 'Authors'
            'comparator': 'authors'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Year'
            'comparator': 'year'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
        ]
    WS_COLLECTIONS:
      DRUG_LIST:
        MODEL: Drug
        BASE_URL: Settings.WS_BASE_URL + 'molecule.json'
        DEFAULT_PAGE_SIZE: Settings.TABLE_PAGE_SIZES[2]
        AVAILABLE_PAGE_SIZES: Settings.TABLE_PAGE_SIZES
        COLUMNS: [
          {
            'name_to_show': 'ChEMBL ID'
            'comparator': 'molecule_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/compound_report_card/$$$'
            'image_base_url': Settings.WS_BASE_URL + 'image/$$$.svg'
          }
          {
            'name_to_show': 'Molecule Type'
            'comparator': 'molecule_type'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Name'
            'comparator': 'pref_name'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Max Phase'
            'comparator': 'max_phase'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Dosed Ingredient:'
            'comparator': 'dosed_ingredient'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
        ]
      DOCS_BY_TERM_LIST:
        MODEL: Document
        BASE_URL: 'base_url is set by initURL'
        DEFAULT_PAGE_SIZE: Settings.TABLE_PAGE_SIZES[2]
        AVAILABLE_PAGE_SIZES: Settings.TABLE_PAGE_SIZES
        COLUMNS: [
          {
            'name_to_show': 'CHEMBL_ID'
            'comparator': 'document_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/document_report_card/$$$'
          }
          {
            'name_to_show': 'Score'
            'comparator': 'score'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'custom_field_template': '<b>Score: </b>{{val}}'
          }
          {
            'name_to_show': 'Title'
            'comparator': 'title'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'custom_field_template': '<i>{{val}}</i>'
          }
          {
            'name_to_show': 'Authors'
            'comparator': 'authors'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Year'
            'comparator': 'year'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'

          }
        ]
    CLIENT_SIDE_WS_COLLECTIONS:
      # used for targets
      APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST:
        MODEL: ApprovedDrugClinicalCandidate
        DEFAULT_PAGE_SIZE: 10
        AVAILABLE_PAGE_SIZES: Settings.TABLE_PAGE_SIZES
        COLUMNS: [
          {
            'name_to_show': 'ChEMBL ID'
            'comparator': 'molecule_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/compound_report_card/$$$'
          }
          {
            'name_to_show': 'Name'
            'comparator': 'pref_name'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Mechanism of Action'
            'comparator': 'mechanism_of_action'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Max Phase'
            'comparator': 'max_phase'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'References'
            'comparator': 'references'
            'sort_disabled': true
            'is_sorting': 0
          }
        ]
      # used for targets
      TARGET_RELATIONS_LIST:
        MODEL: TargetRelation
        DEFAULT_PAGE_SIZE: 5
        AVAILABLE_PAGE_SIZES: Settings.TABLE_PAGE_SIZES
        COLUMNS: [
          {
            'name_to_show': 'ChEMBL ID'
            'comparator': 'target_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/target_report_card/$$$'
          }
          {
            'name_to_show': 'Relationship'
            'comparator': 'relationship'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Pref Name'
            'comparator': 'pref_name'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Target Type'
            'comparator': 'target_type'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
        ]
