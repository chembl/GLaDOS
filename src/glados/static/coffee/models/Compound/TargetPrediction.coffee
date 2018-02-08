glados.useNameSpace 'glados.models.Compound',
  TargetPrediction: Backbone.Model.extend
    idAttribute: 'pred_id'

    parse: (response) ->

      response.target_link = Target.get_report_card_url(response.target_chembl_id)
      return response

glados.models.Compound.TargetPrediction.COLUMNS =
  PRED_ID:
    name_to_show: 'Pred ID'
    comparator: 'pred_id'
  TARGET_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_chembl_id'
    link_base:'target_link'
  ORGANISM:
    name_to_show: 'Organism'
    comparator: 'target_organism'
  SCORE:
    name_to_show: 'Score'
    comparator: 'probability'
    parse_function: (value) -> parseFloat(value).toFixed(3)

glados.models.Compound.TargetPrediction.ID_COLUMN = glados.models.Compound.TargetPrediction.COLUMNS.PRED_ID

glados.models.Compound.TargetPrediction.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.Compound.TargetPrediction.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    glados.models.Compound.TargetPrediction.COLUMNS.TARGET_CHEMBL_ID
    glados.models.Compound.TargetPrediction.COLUMNS.ORGANISM
    glados.models.Compound.TargetPrediction.COLUMNS.SCORE
  ]
