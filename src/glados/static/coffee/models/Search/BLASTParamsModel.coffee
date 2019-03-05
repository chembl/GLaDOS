glados.useNameSpace 'glados.models.Search',

  # This model handles the communication with the server for structure searches
  BLASTParamsModel: Backbone.Model.extend

    initialize: ->
      @url = "#{glados.Settings.GLADOS_BASE_PATH_REL}api/chembl/sssearch/blast-params/"

    paramsLoaded: -> false