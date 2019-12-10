# This model handles the communication with the server for getting the classification of assays
glados.useNameSpace 'glados.models.visualisation',

  AssayClassificationModel: Backbone.Model.extend

    url: ->

      baseUrl = "#{glados.Settings.GLADOS_API_BASE_URL}/visualisations/assay_classifications"
      type = @get('type')
      if type == glados.models.visualisation.AssayClassificationModel.Types.IN_VIVO
        return "#{baseUrl}/in_vivo"

    setUpTreeLinks: (node) ->

      node.link = Assay.getAssaysListURL(node.query_string)

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

glados.models.visualisation.AssayClassificationModel.Types =
  IN_VIVO: 'IN_VIVO'