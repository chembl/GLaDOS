describe "Protein Target Classification", ->

  it 'Sets up the url correctly for protein classification', ->

    proteinClassificationModel = new glados.models.visualisation.TargetClassification
      type: glados.models.visualisation.TargetClassification.Types.PROTEIN_CLASSIFICATION

    console.log('proteinClassificationModel: ', proteinClassificationModel)