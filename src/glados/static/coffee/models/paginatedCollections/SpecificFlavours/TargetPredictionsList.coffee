glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  TargetPredictionsList:

    initURL: -> @url = "https://www.ebi.ac.uk/chembl/target-predictions"

    fetch: ->

      deferred = $.post
        url: @url
        data: JSON.stringify({'smiles': @canonical_smiles})
        dataType: 'json'
        contentType: 'application/json'
        mimeType: 'application/json'

      thisList = @
      deferred.done (data) ->

        parsedData = thisList.parse(data)
        thisList.reset(parsedData)

    parse: (data) ->

      parsedPredictions = []
      for pred in data

        parsedProps =
          'molecule_chembl_id': @molecule_chembl_id
          target_chembl_id: pred['target_chemblid']
          target_organism: pred['organism']
          target_pref_name: pred['pref_name']
          confidence_70: pred['70%']
          confidence_80: pred['80%']
          confidence_90: pred['90%']

        parsedProperties = glados.models.Compound.TargetPrediction.prototype.parse(parsedProps)
        parsedPredictions.push(new glados.models.Compound.TargetPrediction(parsedProperties))

      parsedPredictions = _.sortBy(parsedPredictions, 'confidence_80')

      @reset(parsedPredictions)
