glados.useNameSpace 'glados.models.Compound',
  StructuralAlert: Backbone.Model.extend

    parse: (response) ->
      console.log 'AAA parsing st alerts!!'
      response.image_url = "#{glados.Settings.WS_BASE_URL}compound_structural_alert/#{response.cpd_str_alert_id}.svg"
      return response

glados.models.Compound.StructuralAlert.COLUMNS =
  ALERT_ID:
    name_to_show: 'Alert ID'
    comparator: 'cpd_str_alert_id'
    image_base_url: 'image_url'
  ALERT_NAME:
    name_to_show: 'Alert Name'
    comparator: 'alert_name'

glados.models.Compound.StructuralAlert.ID_COLUMN = glados.models.Compound.StructuralAlert.COLUMNS.ALERT_ID

glados.models.Compound.StructuralAlert.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.StructuralAlert.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_REPORT_CARD_CAROUSEL: [
    glados.models.Compound.StructuralAlert.COLUMNS.ALERT_ID
    glados.models.Compound.StructuralAlert.COLUMNS.ALERT_NAME
  ]
