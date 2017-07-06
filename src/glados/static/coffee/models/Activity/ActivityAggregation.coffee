glados.useNameSpace 'glados.models.Activity',
  ActivityAggregation: Backbone.Model.extend
    initialize: -> console.log 'init ActivityAggregation'

glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD =
  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  TEMPLATE: 'Handlebars-Common-MiniReportCard'
#  COLUMNS: Target.COLUMNS_SETTINGS.RESULTS_LIST_TABLE