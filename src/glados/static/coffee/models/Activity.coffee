Activity = Backbone.Model.extend

  initialize: ->
    console.log 'initialising activity!'

  parse: (response) ->
    response.image_url = glados.Settings.WS_BASE_URL + 'image/' + response.molecule_chembl_id + '.svg?engine=indigo'
    response.molecule_link = Compound.get_report_card_url(response.molecule_chembl_id )
    response.target_link = Target.get_report_card_url(response.target_chembl_id)
    response.assay_link = Assay.get_report_card_url(response.assay_chembl_id )
    return response

Activity.COLUMNS = {
  COMMENT: {
    'name_to_show': 'Activity Comment'
    'comparator': 'activity_comment'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ACTIVITY_ID: {
    'name_to_show': 'Activity id'
    'comparator': 'activity_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ASSAY_CHEMBL_ID: {
    'name_to_show': 'Assay'
    'comparator': 'assay_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base':'assay_link'
    'secondary_link': true
  }
  ASSAY_DESCRIPTION: {
    'name_to_show': 'Assay Description'
    'comparator': 'assay_description'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ASSAY_TYPE: {
    'name_to_show': 'Type'
    'comparator': 'assay_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  BAO_FORMAT: {
    'name_to_show': 'BAO Format'
    'comparator': 'bao_format'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  CANONICAL_SMILES: {
    'name_to_show': 'Canonical Smiles'
    'comparator': 'canonical_smiles'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  DATA_VALIDITY_COMMENT: {
    'name_to_show': 'Data Validity Comment'
    'comparator': 'data_validity_comment'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  DOCUMENT_CHEMBL_ID: {
    'name_to_show': 'Document ChEMBL ID'
    'comparator': 'document_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  DOCUMENT_JOURNAL: {
    'name_to_show': 'Document Journal'
    'comparator': 'document_journal'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  DOCUMENT_YEAR: {
    'name_to_show': 'Document Year'
    'comparator': 'document_year'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  MOLECULE_CHEMBL_ID: {
    'name_to_show': 'Molecule'
    'comparator': 'molecule_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'image_base_url': 'image_url'
    'link_base':'molecule_link'
    'secondary_link': true
  }
  STANDARD_TYPE: {
    'name_to_show': 'Standard Type'
    'comparator': 'standard_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PCHEMBL_VALUE: {
    'name_to_show': 'PchEMBL Value'
    'comparator': 'pchembl_value'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  POTENTIAL_DUPLICATE: {
    'name_to_show': 'Potential Duplicate'
    'comparator': 'potential_duplicate'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PUBLISHED_RELATION: {
    'name_to_show': 'Published Relation'
    'comparator': 'published_relation'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PUBLISHED_TYPE: {
    'name_to_show': 'Published Type'
    'comparator': 'published_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PUBLISHED_UNITS: {
    'name_to_show': 'Published Units'
    'comparator': 'published_units'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  PUBLISHED_VALUE: {
    'name_to_show': 'Published Units'
    'comparator': 'published_value'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  QUDT_UNITS: {
    'name_to_show': 'QUDT Units'
    'comparator': 'qudt_units'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RECORD_ID: {
    'name_to_show': 'Record ID'
    'comparator': 'record_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  SRC_ID: {
    'name_to_show': 'SRC ID'
    'comparator': 'src_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  STANDARD_FLAG: {
    'name_to_show': 'Standard Flag'
    'comparator': 'standard_flag'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  STANDARD_RELATION: {
    'name_to_show': 'Standard Relation'
    'comparator': 'standard_relation'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  STANDARD_TYPE: {
    'name_to_show': 'Standard Type'
    'comparator': 'standard_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  STANDARD_UNITS: {
    'name_to_show': 'Standard Units'
    'comparator': 'standard_units'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  STANDARD_VALUE: {
    'name_to_show': 'Standard Value'
    'comparator': 'standard_value'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  TARGET_CHEMBL_ID: {
    'name_to_show': 'Target'
    'comparator': 'target_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base':'target_link'
    'secondary_link': true
  }
  TARGET_ORGANISM: {
    'name_to_show': 'Target Organism'
    'comparator': 'target_organism'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  TARGET_PREF_NAME: {
    'name_to_show': 'Target Preferred Name'
    'comparator': 'target_pref_name'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  UO_UNITS: {
    'name_to_show': 'UO Units'
    'comparator': 'uo_units'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
}

Activity.ID_COLUMN = Activity.COLUMNS.ACTIVITY_ID

Activity.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    Activity.COLUMNS.MOLECULE_CHEMBL_ID
    Activity.COLUMNS.ACTIVITY_ID,
    Activity.COLUMNS.ASSAY_CHEMBL_ID,
    Activity.COLUMNS.MOLECULE_CHEMBL_ID,
    Activity.COLUMNS.TARGET_CHEMBL_ID,
    Activity.COLUMNS.STANDARD_TYPE
    Activity.COLUMNS.TARGET_ORGANISM
  ]
}

Activity.getActivitiesListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'activities/filter/' + filter
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'activities'