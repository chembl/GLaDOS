Activity = Backbone.Model.extend

  initialize: ->
    console.log 'initialising activity!'

Activity.COLUMNS = {
  ACTIVITY_ID: {
    'name_to_show': 'ChEMBL ID'
    'comparator': 'activity_id'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
}

Activity.ID_COLUMN = Activity.COLUMNS.ACTIVITY_ID

Activity.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [Activity.COLUMNS.ACTIVITY_ID]
}