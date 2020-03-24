glados.useNameSpace 'glados.models.Compound',
  TargetPrediction: Backbone.Model.extend
    idAttribute: 'pred_id'

    parse: (response) ->

      response.target_link = Target.get_report_card_url(response.target_chembl_id)
      if response.in_training == true
        response.activities_link = Activity.getActivitiesListURL(
          "molecule_chembl_id:#{response.molecule_chembl_id} AND target_chembl_id:#{response.target_chembl_id}")
      return response

glados.models.Compound.TargetPrediction.COLUMNS =
  PRED_ID:
    name_to_show: 'Pred ID'
    comparator: 'pred_id'
  TARGET_CHEMBL_ID: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_chembl_id'
    link_base:'target_link'
  TARGET_PREF_NAME: glados.models.paginatedCollections.ColumnsFactory.generateColumn Activity.indexName,
    comparator: 'target_pref_name'
  ORGANISM:
    name_to_show: 'Organism'
    comparator: 'target_organism'
  CONFIDENCE_70:
    name_to_show: 'Confidence 70%'
    comparator: 'confidence_70'
  CONFIDENCE_80:
    name_to_show: 'Confidence 80%'
    comparator: 'confidence_80'
  CONFIDENCE_90:
    name_to_show: 'Confidence 90%'
    comparator: 'confidence_90'
  IN_TRAINING:
    name_to_show: 'In Training Set'
    comparator: 'in_training'
    link_base: 'activities_link'
    parse_function: (value) ->
      if value == true
        return 'yes (Click to see activities)'
      else
        return 'no'

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
    glados.models.Compound.TargetPrediction.COLUMNS.TARGET_PREF_NAME
    glados.models.Compound.TargetPrediction.COLUMNS.ORGANISM
    glados.models.Compound.TargetPrediction.COLUMNS.CONFIDENCE_70
    glados.models.Compound.TargetPrediction.COLUMNS.CONFIDENCE_80
    glados.models.Compound.TargetPrediction.COLUMNS.CONFIDENCE_90
#    glados.models.Compound.TargetPrediction.COLUMNS.IN_TRAINING
  ]

glados.models.Compound.TargetPrediction.CONDITIONAL_ROW_FORMATS =
  COMPOUND_REPORT_CARD: (model) ->
    if model.get('in_training') == true
      return {
        color: glados.Settings.VIS_COLORS.LIGHT_GREEN5
      }