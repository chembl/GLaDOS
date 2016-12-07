CellLine = Backbone.Model.extend

  initialize: ->

    @url = glados.Settings.WS_BASE_URL + 'cell_line/' + @get('cell_chembl_id') + '.json'