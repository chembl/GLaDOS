# This model handles the communication with the server for getting the classification of targets
glados.useNameSpace 'glados.models.visualisation',

  TargetClassificationModel: Backbone.Model.extend

    url: ->

      baseUrl = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/target_classifications"
      type = @get('type')
      if type == glados.models.visualisation.TargetClassificationModel.Types.PROTEIN_CLASSIFICATION
        return "#{baseUrl}/protein_class"
      else if type == glados.models.visualisation.TargetClassificationModel.Types.ORGANISM_TAXONOMY
        return "#{baseUrl}/organism_taxonomy"
      else if type == glados.models.visualisation.TargetClassificationModel.Types.GENE_ONTOLOGY
        return "#{baseUrl}/go_slim"

    setUpTreeLinks: (node) ->

      node.link = Target.getTargetsListURL(node.query_string)

      children = node.children
      if children?
        for nodeID, node of children
          @setUpTreeLinks(node)

    parse: (data) ->

      tree = {
        'root': {
          'children': data
        }
      }
      @setUpTreeLinks(tree['root'])
      return tree

glados.models.visualisation.TargetClassificationModel.Types =
  PROTEIN_CLASSIFICATION: 'PROTEIN_CLASSIFICATION'
  ORGANISM_TAXONOMY: 'ORGANISM_TAXONOMY'
  GENE_ONTOLOGY: 'GENE_ONTOLOGY'