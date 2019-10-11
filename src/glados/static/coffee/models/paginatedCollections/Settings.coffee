glados.useNameSpace 'glados.models.paginatedCollections',
  # --------------------------------------------------------------------------------------------------------------------
  # Elastic Search specific configuration settings
  # --------------------------------------------------------------------------------------------------------------------
  Settings:
    ES_BASE_URL: glados.Settings.ES_BASE_URL
    ES_INDEXES:
      COMPOUND:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESCompound'
        LABEL: 'Compounds'
        INDEX_NAME: 'chembl_molecule'
        BROWSE_LIST_URL: Compound.getCompoundsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Compound
        PERMANENT_COMPARATORS_TO_FETCH:['molecule_chembl_id',
          'molecule_properties.num_ro5_violations', 'molecule_properties.full_molformula', 'molecule_type',
          'natural_product', 'polymer_flag', 'structure_type']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Cards}": 'browser_cards'
        ID_COLUMN: Compound.ID_COLUMN
        CUSTOM_DEFAULT_CARD_SIZES:
          small: 12
          medium: 6
          large: 4
        CUSTOM_CARD_SIZE_TO_PAGE_SIZES:
          12: 6
          6: 12
          4: 24
          3: 24
          2: 96
          1: 192
        ENABLE_CARDS_ZOOM: true
        CUSTOM_CARDS_TEMPLATE: 'Handlebars-Common-Paginated-Card-Compound'
        CUSTOM_CARDS_ITEM_VIEW: glados.views.PaginatedViews.ItemCardView
        COMPLICATE_CARDS_VIEW: true
        COMPLICATE_CARDS_COLUMNS: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_LONG
        ADDITIONAL_COLUMNS: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_ADDITIONAL
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.CompoundSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV'], glados.Settings.DEFAULT_FILE_FORMAT_NAMES['SDF']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Graph'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards']
        ENABLE_COLLECTION_CACHING: true
        POSSIBLE_CARD_SIZES_STRUCT:
          1:
            previous: 1
            next: 2
          2:
            previous: 1
            next: 4
          3:
            previous: 2
            next: 4
          4:
            previous: 2
            next: 6
          6:
            previous: 4
            next: 12
          12:
            previous: 6
            next: 12
        LINKS_TO_OTHER_ENTITIES: [
          Activity.prototype.entityName,
          glados.models.Compound.MechanismOfAction.prototype.entityName,
          glados.models.Compound.DrugIndication.prototype.entityName
        ]
        ENABLE_TEXT_FILTER: true
      TARGET:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESTarget'
        LABEL: 'Targets'
        INDEX_NAME: 'chembl_target'
        BROWSE_LIST_URL: Target.getTargetsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Target
        PERMANENT_COMPARATORS_TO_FETCH: ['target_chembl_id', 'cross_references', 'target_components']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        ID_COLUMN: Target.ID_COLUMN
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.TargetSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [Activity.prototype.entityName]
        ENABLE_TEXT_FILTER: true
      ASSAY:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESAssay'
        LABEL: 'Assays'
        INDEX_NAME: 'chembl_assay'
        BROWSE_LIST_URL: Assay.getAssaysListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Assay
        PERMANENT_COMPARATORS_TO_FETCH: ['assay_chembl_id', 'document_chembl_id', 'tissue_chembl_id', 'src_id',
          'src_assay_id', '_metadata.document_data.doi', '_metadata.document_data.pubmed_id']
        ID_COLUMN: Assay.ID_COLUMN
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.AssaySchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [Activity.prototype.entityName]
        ENABLE_TEXT_FILTER: true
      DOCUMENT:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESDocument'
        LABEL: 'Documents'
        INDEX_NAME: 'chembl_document'
        BROWSE_LIST_URL: Document.getDocumentsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Document
        ID_COLUMN: Document.ID_COLUMN
        PERMANENT_COMPARATORS_TO_FETCH: ['document_chembl_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.DocumentSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [Activity.prototype.entityName]
        ENABLE_TEXT_FILTER: true
      CELL_LINE:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESCellLine'
        LABEL: 'Cells'
        INDEX_NAME: 'chembl_cell_line'
        BROWSE_LIST_URL: CellLine.getCellsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: CellLine
        ID_COLUMN: CellLine.ID_COLUMN
        PERMANENT_COMPARATORS_TO_FETCH: ['cell_chembl_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.CellLineSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [Activity.prototype.entityName]
        ENABLE_TEXT_FILTER: true
      TISSUE:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESTissue'
        LABEL: 'Tissues'
        INDEX_NAME: 'chembl_tissue'
        BROWSE_LIST_URL: glados.models.Tissue.getTissuesListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: glados.models.Tissue
        ID_COLUMN: glados.models.Tissue.ID_COLUMN
        PERMANENT_COMPARATORS_TO_FETCH: ['tissue_chembl_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.TissueSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [Activity.prototype.entityName]
        ENABLE_TEXT_FILTER: true
    ES_INDEXES_NO_MAIN_SEARCH:
      ACTIVITY:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESActivitity'
        LABEL: 'Activities'
        INDEX_NAME: 'chembl_activity'
        BROWSE_LIST_URL: Activity.getActivitiesListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Activity
        ID_COLUMN: Activity.ID_COLUMN
        PERMANENT_COMPARATORS_TO_FETCH: ['_metadata.parent_molecule_data.image_file', 'molecule_chembl_id',
          'target_chembl_id', 'assay_chembl_id', 'document_chembl_id', '_metadata.assay_data.tissue_chembl_id',
          'activity_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        DEFAULT_PAGE_SIZE: glados.Settings.TABLE_PAGE_SIZES[2]
        AVAILABLE_PAGE_SIZES: glados.Settings.TABLE_PAGE_SIZES
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.ActivitySchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        LINKS_TO_OTHER_ENTITIES: [Compound.prototype.entityName, Target.prototype.entityName,
          Assay.prototype.entityName, Document.prototype.entityName]
        ID_COLUMN: Activity.ID_COLUMN
        ENABLE_TEXT_FILTER: true
      COMPOUND_ES_RESULTS_LIST_CAROUSEL:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESCompound'
        LABEL: 'Compounds'
        INDEX_NAME: 'chembl_molecule'
        BROWSE_LIST_URL: Compound.getCompoundsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Compound
        PERMANENT_COMPARATORS_TO_FETCH:['molecule_chembl_id',
          'molecule_properties.num_ro5_violations', 'molecule_properties.full_molformula', 'molecule_type',
          'natural_product', 'polymer_flag', 'structure_type']
        AVAILABLE_PAGE_SIZES: glados.Settings.TABLE_PAGE_SIZES
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Carousel}": 'alternate_forms_carousel'
        ID_COLUMN: Compound.ID_COLUMN
        IS_CAROUSEL: true
      COMPOUND_COOL_CARDS:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESCompound'
        LABEL: 'Compounds'
        INDEX_NAME: 'chembl_molecule'
        BROWSE_LIST_URL: Compound.getCompoundsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Compound
        PERMANENT_COMPARATORS_TO_FETCH:['molecule_chembl_id',
          'molecule_properties.num_ro5_violations', 'molecule_properties.full_molformula', 'molecule_type',
          'natural_product', 'polymer_flag', 'structure_type']
        ID_COLUMN: Compound.ID_COLUMN
        ENABLE_CARDS_ZOOM: true
        CUSTOM_CARDS_TEMPLATE: 'Handlebars-Common-Paginated-Card-Compound'
        CUSTOM_CARDS_ITEM_VIEW: glados.views.PaginatedViews.ItemCardView
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.CompoundSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV'], glados.Settings.DEFAULT_FILE_FORMAT_NAMES['SDF']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Graph'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Cards}": 'browser_cards'
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [
          Activity.prototype.entityName,
          glados.models.Compound.MechanismOfAction.prototype.entityName,
          glados.models.Compound.DrugIndication.prototype.entityName
        ]
        ENABLE_TEXT_FILTER: true
      COMPOUND_SUBSTRUCTURE_HIGHLIGHTING:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESCompound'
        LABEL: 'Compounds'
        INDEX_NAME: 'chembl_molecule'
        BROWSE_LIST_URL: Compound.getCompoundsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Compound
        PERMANENT_COMPARATORS_TO_FETCH:['molecule_chembl_id',
          'molecule_properties.num_ro5_violations', 'molecule_properties.full_molformula', 'molecule_type',
          'natural_product', 'polymer_flag', 'structure_type']
        ID_COLUMN: Compound.ID_COLUMN
        ENABLE_CARDS_ZOOM: true
        CUSTOM_CARDS_TEMPLATE: 'Handlebars-Common-Paginated-Card-Compound'
        CUSTOM_CARDS_ITEM_VIEW: glados.views.PaginatedViews.ItemCardView
        ADDITIONAL_COLUMNS: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_ADDITIONAL
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.CompoundSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV'], glados.Settings.DEFAULT_FILE_FORMAT_NAMES['SDF']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Graph'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Cards}": 'browser_cards'
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards']
        ENABLE_SUBSTRUCTURE_HIGHLIGHTING: true
        SHOW_SUBSTRUCTURE_HIGHLIGHTING: true
        ENABLE_COLLECTION_CACHING: true
        DISABLE_CACHE_ON_DOWNLOAD: true
        LINKS_TO_OTHER_ENTITIES: [
          Activity.prototype.entityName,
          glados.models.Compound.MechanismOfAction.prototype.entityName,
          glados.models.Compound.DrugIndication.prototype.entityName
        ]
        ENABLE_TEXT_FILTER: true
      TARGET_BLAST_RESULTS:
        ID_NAME: 'ESTarget'
        LABEL: 'Targets'
        INDEX_NAME: 'chembl_target'
        BROWSE_LIST_URL: Target.getTargetsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Target
        ID_COLUMN: Target.ID_COLUMN
        PERMANENT_COMPARATORS_TO_FETCH: ['target_chembl_id', 'cross_references', 'target_components']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table_blast'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.TargetSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']
        ENABLE_COLLECTION_CACHING: true
        LINKS_TO_OTHER_ENTITIES: [Activity.prototype.entityName]
        DOWNLOAD_COLUMNS_GROUP: 'download_blast'
        ENABLE_TEXT_FILTER: true
      COMPOUND_SIMILARITY_MAPS:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESCompound'
        LABEL: 'Compounds'
        INDEX_NAME: 'chembl_molecule'
        BROWSE_LIST_URL: Compound.getCompoundsListURL
        # PATH: Assigned after this declaration using the INDEX_NAME
        MODEL: Compound
        PERMANENT_COMPARATORS_TO_FETCH:['molecule_chembl_id',
          'molecule_properties.num_ro5_violations', 'molecule_properties.full_molformula', 'molecule_type',
          'natural_product', 'polymer_flag', 'structure_type']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table_similarity'
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Cards}": 'browser_cards_similarity'
        ID_COLUMN: Compound.ID_COLUMN
        ENABLE_CARDS_ZOOM: true
        CUSTOM_CARDS_TEMPLATE: 'Handlebars-Common-Paginated-Card-Compound'
        CUSTOM_CARDS_ITEM_VIEW: glados.views.PaginatedViews.ItemCardView
        ADDITIONAL_COLUMNS: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_ADDITIONAL
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.CompoundSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV'], glados.Settings.DEFAULT_FILE_FORMAT_NAMES['SDF']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Graph'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards']
        ENABLE_SIMILARITY_MAPS: true
        SHOW_SIMILARITY_MAPS: false
        ENABLE_COLLECTION_CACHING: true
        DISABLE_CACHE_ON_DOWNLOAD: true
        LINKS_TO_OTHER_ENTITIES: [
          Activity.prototype.entityName,
          glados.models.Compound.MechanismOfAction.prototype.entityName,
          glados.models.Compound.DrugIndication.prototype.entityName
        ]
        DOWNLOAD_COLUMNS_GROUP: 'download_similarity'
        ENABLE_TEXT_FILTER: true
      DRUGS_LIST:
        # KEY_NAME: Assigned after this declaration using the same string used for the key in ES_INDEXES
        ID_NAME: 'ESDrugs'
        LABEL: 'Drugs'
        INDEX_NAME: 'chembl_molecule'
        # PATH: Assigned after this declaration using the INDEX_NAME
        BROWSE_LIST_URL: Drug.getDrugsListURL
        MODEL: glados.models.Compound.Drug
        PERMANENT_COMPARATORS_TO_FETCH: ['molecule_chembl_id',
          'molecule_properties.num_ro5_violations', 'molecule_properties.full_molformula', 'molecule_type',
          'natural_product', 'polymer_flag', 'structure_type', '_metadata.drug.drug_data.sc_patent']
        ID_COLUMN: glados.models.Compound.Drug.ID_COLUMN
        ENABLE_CARDS_ZOOM: true
        CUSTOM_CARDS_TEMPLATE: 'Handlebars-Common-Paginated-Card-Compound'
        CUSTOM_CARDS_ITEM_VIEW: glados.views.PaginatedViews.ItemCardView
        CUSTOM_CARD_ITEM_VIEW_DETAILS_COLUMNS: glados.models.Compound.Drug.COLUMNS_SETTINGS.CARD_DETAILS
        ADDITIONAL_COLUMNS: Drug.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_ADDITIONAL
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.CompoundSchema.FACETS_GROUPS
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV'], glados.Settings.DEFAULT_FILE_FORMAT_NAMES['SDF']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Graph'],
          glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Heatmap]
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table_drugs'
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Cards}": 'browser_cards_drugs'
        DEFAULT_VIEW: glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Cards']
        ENABLE_COLLECTION_CACHING: true
        DISABLE_CACHE_ON_DOWNLOAD: true
        LINKS_TO_OTHER_ENTITIES: [
          Activity.prototype.entityName,
          glados.models.Compound.MechanismOfAction.prototype.entityName,
          glados.models.Compound.DrugIndication.prototype.entityName
        ]
        DOWNLOAD_COLUMNS_GROUP: 'download_drugs'
        ENABLE_TEXT_FILTER: true
      DRUG_INDICATIONS:
        ID_NAME: 'ESDrugIndications'
        LABEL: 'Drug Indications'
        INDEX_NAME: 'chembl_drug_indication_by_parent'
        # PATH: Assigned after this declaration using the INDEX_NAME
        #BROWSE_LIST_URL: Drug.getDrugsListURL
        BROWSE_LIST_URL: glados.models.Compound.DrugIndication.getListURL
        MODEL: glados.models.Compound.DrugIndication
        PERMANENT_COMPARATORS_TO_FETCH: ['parent_molecule._metadata.compound_generated.image_file',
          'parent_molecule.molecule_chembl_id', 'drug_indication.mesh_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.DrugIndicationSchema.FACETS_GROUPS
        ID_COLUMN: glados.models.Compound.DrugIndication.ID_COLUMN
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        ENABLE_TEXT_FILTER: true
        LINKS_TO_OTHER_ENTITIES: [
          glados.models.Compound.Drug.prototype.browseLinkEntityName,
          Compound.prototype.entityName
        ]
      DRUG_INDICATIONS_COMPOUND_REPORT_CARD:
        ID_NAME: 'ESDrugIndications'
        LABEL: 'Drug Indications'
        INDEX_NAME: 'chembl_drug_indication_by_parent'
        # PATH: Assigned after this declaration using the INDEX_NAME
        #BROWSE_LIST_URL: Drug.getDrugsListURL
        BROWSE_LIST_URL: glados.models.Compound.DrugIndication.getListURL
        MODEL: glados.models.Compound.DrugIndication
        PERMANENT_COMPARATORS_TO_FETCH: ['parent_molecule._metadata.compound_generated.image_file',
          'parent_molecule.molecule_chembl_id', 'drug_indication.mesh_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'report_card_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.DrugIndicationSchema.FACETS_GROUPS
        ID_COLUMN: glados.models.Compound.DrugIndication.ID_COLUMN
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
      MECHANISMS_OF_ACTION:
        ID_NAME: 'ESMechsOfAction'
        LABEL: 'Mechanisms of Action'
        INDEX_NAME: 'chembl_mechanism_by_parent_target'
        BROWSE_LIST_URL: glados.models.Compound.MechanismOfAction.getListURL
        MODEL: glados.models.Compound.MechanismOfAction
        PERMANENT_COMPARATORS_TO_FETCH: ['parent_molecule._metadata.compound_generated.image_file',
          'parent_molecule.molecule_chembl_id', 'target.target_chembl_id', 'mechanism_of_action.mec_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'browser_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.MechanismSchema.FACETS_GROUPS
        ID_COLUMN: glados.models.Compound.MechanismOfAction.ID_COLUMN
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
        LINKS_TO_OTHER_ENTITIES: [
          glados.models.Compound.Drug.prototype.browseLinkEntityName,
          Compound.prototype.entityName,
          Target.prototype.entityName
        ]
        ENABLE_TEXT_FILTER: true
      MECHANISMS_OF_ACTION_COMPOUND_REPORT_CARD:
        ID_NAME: 'ESMechsOfAction'
        LABEL: 'Mechanisms of Action'
        INDEX_NAME: 'chembl_mechanism_by_parent_target'
        BROWSE_LIST_URL: glados.models.Compound.MechanismOfAction.getListURL
        MODEL: glados.models.Compound.MechanismOfAction
        PERMANENT_COMPARATORS_TO_FETCH: ['parent_molecule._metadata.compound_generated.image_file',
          'parent_molecule.molecule_chembl_id', 'target.target_chembl_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'report_card_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.MechanismSchema.FACETS_GROUPS
        ID_COLUMN: glados.models.Compound.MechanismOfAction.ID_COLUMN
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
      MECHANISMS_OF_ACTION_TARGET_REPORT_CARD:
        ID_NAME: 'ESMechsOfAction'
        LABEL: 'Mechanisms of Action'
        INDEX_NAME: 'chembl_mechanism_by_parent_target'
        BROWSE_LIST_URL: glados.models.Compound.MechanismOfAction.getListURL
        MODEL: glados.models.Compound.MechanismOfAction
        PERMANENT_COMPARATORS_TO_FETCH: ['parent_molecule._metadata.compound_generated.image_file',
          'parent_molecule.molecule_chembl_id', 'target.target_chembl_id']
        CONFIG_GROUPS:
          "#{glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES.Table}": 'target_report_card_table'
        FACETS_GROUPS: glados.models.paginatedCollections.esSchema.MechanismSchema.FACETS_GROUPS
        ID_COLUMN: glados.models.Compound.MechanismOfAction.ID_COLUMN
        DOWNLOAD_FORMATS: [glados.Settings.DEFAULT_FILE_FORMAT_NAMES['CSV'],
          glados.Settings.DEFAULT_FILE_FORMAT_NAMES['TSV']]
        AVAILABLE_VIEWS: [glados.Settings.DEFAULT_RESULTS_VIEWS_NAMES['Table']]
    WS_COLLECTIONS:
      TWEETS_LIST:
        MODEL: glados.models.MainPage.Tweet
        BASE_URL: 'base_url is set by initURL'
        DEFAULT_PAGE_SIZE: 15
        COLUMNS: glados.models.MainPage.Tweet.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Infinite:
            Default: glados.models.MainPage.Tweet.COLUMNS_SETTINGS.INFINITE_VIEW
            CustomItemTemplate: 'Handlebars-Common-Paginated-Card-Tweet'
        ID_COLUMN: glados.models.MainPage.Tweet.ID_COLUMN
      BLOG_ENTRIES_LIST:
        MODEL: glados.models.MainPage.BlogEntry
        BASE_URL: 'base_url is set by initURL'
        DEFAULT_PAGE_SIZE: 15
        COLUMNS: glados.models.MainPage.BlogEntry.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Infinite:
            Default: glados.models.MainPage.BlogEntry.COLUMNS_SETTINGS.INFINITE_VIEW
            CustomItemTemplate: 'Handlebars-Common-Paginated-Card-Blog-Entry'
        ID_COLUMN: glados.models.MainPage.BlogEntry.ID_COLUMN
      COMPOUND_WS_RESULTS_LIST_CAROUSEL:
        MODEL: Compound
        BASE_URL: 'base_url is set by initURL'
        DEFAULT_PAGE_SIZE: "needs to be set up outside, for some reason it doesn't work"
        AVAILABLE_PAGE_SIZES: glados.Settings.TABLE_PAGE_SIZES
        COLUMNS_DESCRIPTION:
          Table:
            Default: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_CAROUSEL
          Cards:
            Default: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_CAROUSEL
          Infinite:
            Default: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_CAROUSEL
          Carousel:
            Default: Compound.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_CAROUSEL
        ID_COLUMN: Compound.ID_COLUMN
        IS_CAROUSEL: true
    CLIENT_SIDE_WS_COLLECTIONS:
      UNICHEM_CONNECTIVITY_LIST:
        MODEL: glados.models.Compound.UnichemConnectivityMatch
        DEFAULT_PAGE_SIZE: 5
        ID_COLUMN: glados.models.Compound.UnichemConnectivityMatch.ID_COLUMN
        COLUMNS: glados.models.Compound.UnichemConnectivityMatch.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: glados.models.Compound.UnichemConnectivityMatch.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
      TARGET_PREDICTIONS:
        MODEL: glados.models.Compound.TargetPrediction
        DEFAULT_PAGE_SIZE: 5
        ID_COLUMN: glados.models.Compound.TargetPrediction.ID_COLUMN
        COLUMNS: glados.models.Compound.TargetPrediction.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: glados.models.Compound.TargetPrediction.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
            ConditionalRowFormatting: glados.models.Compound.TargetPrediction.CONDITIONAL_ROW_FORMATS.COMPOUND_REPORT_CARD
            remove_striping: true
      # used for targets
      APPROVED_DRUGS_CLINICAL_CANDIDATES_LIST:
        MODEL: ApprovedDrugClinicalCandidate
        DEFAULT_PAGE_SIZE: 10
        AVAILABLE_PAGE_SIZES: glados.Settings.TABLE_PAGE_SIZES
        ID_COLUMN: ApprovedDrugClinicalCandidate.ID_COLUMN
        COLUMNS: ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Cards:
            Default: ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Infinite:
            Default: ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Carousel:
            Default: ApprovedDrugClinicalCandidate.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
      SIMILAR_DOCUMENTS_IN_REPORT_CARD:
        MODEL: Document
        DEFAULT_PAGE_SIZE: 5
        COLUMNS: Document.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: Document.COLUMNS_SETTINGS.SIMILAR_TERMS_IN_REPORT_CARDS
            custom_page_sizes: glados.Settings.TABLE_PAGE_SIZES
        ID_COLUMN: Document.ID_COLUMN
      STRUCTURAL_ALERTS_LIST:
        MODEL: glados.models.Compound.StructuralAlert
        COLUMNS: glados.models.Compound.StructuralAlert.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Carousel:
            Default: glados.models.Compound.StructuralAlert.COLUMNS_SETTINGS.RESULTS_LIST_REPORT_CARD_CAROUSEL
        ID_COLUMN: glados.models.Compound.StructuralAlert.ID_COLUMN
      STRUCTURAL_ALERTS_SETS_LIST:
        MODEL: glados.models.Compound.StructuralAlertSet
        DEFAULT_PAGE_SIZE: 3
        ID_COLUMN: glados.models.Compound.StructuralAlertSet.ID_COLUMN
        COLUMNS: glados.models.Compound.StructuralAlertSet.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: glados.models.Compound.StructuralAlertSet.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
            custom_page_sizes: _.union([3], glados.Settings.TABLE_PAGE_SIZES)
      # used for targets
      TARGET_RELATIONS_LIST:
        MODEL: TargetRelation
        DEFAULT_PAGE_SIZE: 5
        AVAILABLE_PAGE_SIZES: glados.Settings.TABLE_PAGE_SIZES
        ID_COLUMN: TargetRelation.ID_COLUMN
        COLUMNS: TargetRelation.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: TargetRelation.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Cards:
            Default: TargetRelation.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Infinite:
            Default: TargetRelation.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Carousel:
            Default: TargetRelation.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
      TARGET_COMPONENTS_LIST:
        MODEL: TargetComponent
        DEFAULT_PAGE_SIZE: 5
        AVAILABLE_PAGE_SIZES: glados.Settings.TABLE_PAGE_SIZES
        ID_COLUMN: TargetComponent.ID_COLUMN
        COLUMNS: TargetComponent.COLUMNS_SETTINGS.ALL_COLUMNS
        COLUMNS_DESCRIPTION:
          Table:
            Default: TargetComponent.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Cards:
            Default: TargetComponent.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Infinite:
            Default: TargetComponent.COLUMNS_SETTINGS.RESULTS_LIST_TABLE
          Carousel:
            Default: TargetComponent.COLUMNS_SETTINGS.RESULTS_LIST_TABLE

glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS= {}

# fills the KEY_NAME for the ES_INDEXES object
# fills the path in the settings for every object
for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES
  val_i.KEY_NAME = key_i
  val_i.PATH = '/'+val_i.INDEX_NAME
  val_i.PATH_IN_SETTINGS = "ES_INDEXES.#{key_i}"
  glados.models.paginatedCollections.Settings.ES_INDEX_2_GLADOS_SETTINGS[val_i.INDEX_NAME] = val_i
for key_i, val_i of glados.models.paginatedCollections.Settings.ES_INDEXES_NO_MAIN_SEARCH
  val_i.KEY_NAME = key_i
  val_i.PATH = '/'+val_i.INDEX_NAME
  val_i.PATH_IN_SETTINGS = "ES_INDEXES_NO_MAIN_SEARCH.#{key_i}"

# Loads the Search results URL's including the ElasticSearch entities configuration
glados.loadSearchResultsURLS()