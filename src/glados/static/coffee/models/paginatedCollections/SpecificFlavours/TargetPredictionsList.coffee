glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  TargetPredictionsList:

    initURL: (chemblID) ->
      @url = "#{glados.Settings.GLADOS_API_BASE_URL}/target_prediction/predictions/#{chemblID}"

    parse: (data) ->
      @reset(data.predictions)
