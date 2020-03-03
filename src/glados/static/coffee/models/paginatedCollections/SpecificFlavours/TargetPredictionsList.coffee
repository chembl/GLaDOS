glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  TargetPredictionsList:

    initURL: (chemblID) ->
      @molecule_chembl_id = chemblID
      @url = "#{glados.Settings.GLADOS_API_BASE_URL}/target_prediction/predictions/#{chemblID}"

    parse: (data) ->

      raw_predictions = _.sortBy(data.predictions, 'confidence_80')

      parsed_predictions = []
      for pred in raw_predictions
        pred['molecule_chembl_id'] = @molecule_chembl_id
        parsed_properties = glados.models.Compound.TargetPrediction.prototype.parse(pred)
        parsed_predictions.push(new glados.models.Compound.TargetPrediction(parsed_properties))

      @reset(raw_predictions)
