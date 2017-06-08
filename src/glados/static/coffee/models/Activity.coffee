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
  TARGET_CHEMBL_ID: {
    'name_to_show': 'Target'
    'comparator': 'target_chembl_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base':'target_link'
    'secondary_link': true
  }
  STANDARD_TYPE: {
    'name_to_show': 'Standard Type'
    'comparator': 'standard_type'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  TARGET_ORGANISM: {
    'name_to_show': 'Target Organism'
    'comparator': 'target_organism'
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