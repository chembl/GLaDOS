# This model handles the communication with the server for getting the classification of targets
glados.useNameSpace 'glados.models.visualisation',

  TargetClassification: Backbone.Model.extend

    url: ->

      baseUrl = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/target_classifications"
      type = @get('type')
      if type == glados.models.visualisation.TargetClassification.Types.PROTEIN_CLASSIFICATION
        return "#{baseUrl}/protein_class"
      else if type == glados.models.visualisation.TargetClassification.Types.ORGANISM_TAXONOMY
        return "#{baseUrl}/organism_taxonomy"
      else if type == glados.models.visualisation.TargetClassification.Types.GENE_ONTOLOGY
        return "#{baseUrl}/go_slim"



    parse: (data) ->

      return {
        'root': {
          'buckets': []
          'bucket_index': data
        }
      }


glados.models.visualisation.TargetClassification.Types =
  PROTEIN_CLASSIFICATION: 'PROTEIN_CLASSIFICATION'
  ORGANISM_TAXONOMY: 'ORGANISM_TAXONOMY'
  GENE_ONTOLOGY: 'GENE_ONTOLOGY'