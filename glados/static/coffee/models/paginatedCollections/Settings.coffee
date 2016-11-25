glados.useNameSpace 'glados.models.paginated_collections'
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

