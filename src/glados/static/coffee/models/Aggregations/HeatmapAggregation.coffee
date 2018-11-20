glados.useNameSpace 'glados.models.Aggregations',
  HeatmapAggregation: glados.models.Aggregations.Aggregation.extend

    initialize: ->
      @set('state', glados.models.Aggregations.HeatmapAggregation.States.INITIAL_STATE)
#      @loadQuery()

glados.models.Aggregations.HeatmapAggregation.States =
  INITIAL_STATE: 'INITIAL_STATE'
