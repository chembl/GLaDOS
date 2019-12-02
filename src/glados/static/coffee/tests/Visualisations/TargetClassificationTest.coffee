describe "Protein Target Classification", ->

  it 'Sets up the url correctly for protein classification', ->

    proteinClassificationModel = new glados.models.visualisation.TargetClassificationModel
      type: glados.models.visualisation.TargetClassificationModel.Types.PROTEIN_CLASSIFICATION

    urlGot = proteinClassificationModel.url()
    urlMustBe = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/target_classifications/protein_class"
    expect(urlGot).toBe(urlMustBe)

  it 'Sets up the url correctly for organism taxonomy', ->

    proteinClassificationModel = new glados.models.visualisation.TargetClassificationModel
      type: glados.models.visualisation.TargetClassificationModel.Types.ORGANISM_TAXONOMY

    urlGot = proteinClassificationModel.url()
    urlMustBe = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/target_classifications/organism_taxonomy"
    expect(urlGot).toBe(urlMustBe)

  it 'Sets up the url correctly for organism taxonomy', ->

    proteinClassificationModel = new glados.models.visualisation.TargetClassificationModel
      type: glados.models.visualisation.TargetClassificationModel.Types.ORGANISM_TAXONOMY

    urlGot = proteinClassificationModel.url()
    urlMustBe = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/target_classifications/organism_taxonomy"
    expect(urlGot).toBe(urlMustBe)

  it 'Sets up the url correctly for Gene Ontology', ->

    proteinClassificationModel = new glados.models.visualisation.TargetClassificationModel
      type: glados.models.visualisation.TargetClassificationModel.Types.GENE_ONTOLOGY

    urlGot = proteinClassificationModel.url()
    urlMustBe = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/target_classifications/go_slim"
    expect(urlGot).toBe(urlMustBe)



