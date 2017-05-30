Activity = Backbone.Model.extend

  initialize: ->
    console.log 'initialising activity!'

  parse: (response) ->
    response.image_url = glados.Settings.WS_BASE_URL + 'image/' + response.molecule_chembl_id + '.svg?engine=indigo'
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
  }
  TARGET_CHEMBL_ID: {
    'name_to_show': 'Target'
    'comparator': 'target_chembl_id'
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
  ]
}

Activity.getActivitiesListURL = (filter) ->

  if filter
    return glados.Settings.GLADOS_BASE_PATH_REL + 'activities/filter/' + filter
  else
    return glados.Settings.GLADOS_BASE_PATH_REL + 'activities'