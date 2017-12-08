glados.useNameSpace 'glados.models.Compound',
  StructuralAlertSet: Backbone.Model.extend {}

glados.models.Compound.StructuralAlertSet.COLUMNS =
  SET_NAME:
    name_to_show: 'Alert Set'
    comparator: 'set_name'
  PRIORITY:
    name_to_show: 'Priority'
    comparator: 'priority'
    format_class: 'number-cell-center'
  ALERTS_LIST:
    name_to_show: 'Alerts'
    comparator: '--'
    sort_disabled: true
    on_click: CompoundReportCardApp.initStructuralAlertsCarouselFromFunctionLink
    function_object_parameter: (attributes) -> attributes.alerts_list
    function_key: 'drug_icon_grid'
    function_link: true
    execute_on_render: true
    hide_value: true
    remove_link_after_click: true


glados.models.Compound.StructuralAlertSet.ID_COLUMN = glados.models.Compound.StructuralAlertSet.COLUMNS.SET_NAME

glados.models.Compound.StructuralAlertSet.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.StructuralAlertSet.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.StructuralAlertSet.COLUMNS.SET_NAME
    glados.models.Compound.StructuralAlertSet.COLUMNS.PRIORITY
    glados.models.Compound.StructuralAlertSet.COLUMNS.ALERTS_LIST
  ]