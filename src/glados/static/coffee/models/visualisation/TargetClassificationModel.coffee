# This model handles the communication with the server for getting the classification of targets
glados.useNameSpace 'glados.models.visualisation',

  TargetClassification: Backbone.Model.extend

    initialize: ->

      console.log('INIT TARGET CLASSIFICATION')
      console.log(@get('type'))


glados.models.visualisation.TargetClassification.Types =
  PROTEIN_CLASSIFICATION: 'PROTEIN_CLASSIFICATION'
  ORGANISM_TAXONOMY: 'ORGANISM_TAXONOMY'
  GENE_ONTOLOGY: 'GENE_ONTOLOGY'