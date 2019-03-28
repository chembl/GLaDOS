glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for getting the parameters of BLAST searches
  BLASTParamsModel: Backbone.Model.extend

    initialize: ->
      @url = "#{glados.Settings.GLADOS_BASE_PATH_REL}glados_api/chembl/sssearch/blast-params/"

    paramsLoaded: -> false