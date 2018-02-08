glados.useNameSpace 'glados.models.Compound',
  TargetPrediction: Backbone.Model.extend
    idAttribute: 'pred_id'

glados.models.Compound.TargetPrediction.COLUMNS =
  PRED_ID:
    name_to_show: 'Pred ID'
    comparator: 'pred_id'

glados.models.Compound.TargetPrediction.ID_COLUMN = glados.models.Compound.TargetPrediction.COLUMNS.PRED_ID

glados.models.Compound.TargetPrediction.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.TargetPrediction.COLUMNS
      colsList.push value
    return colsList
  )()
