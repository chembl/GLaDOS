Compound = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  initialize: ->
    @url = Settings.WS_BASE_URL + 'molecule/' + @get('molecule_chembl_id') + '.json'

  parse: (response) ->

    # Calculate the rule of five from other properties
    if response.molecule_properties?
      response.ro5 = response.molecule_properties.num_ro5_violations == 0
    else
      response.ro5 = false

    return response;