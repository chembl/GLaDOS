CompoundList = Backbone.Collection.extend
  model: Compound

  # This is to allow to load the list from different sources, depending on the source it applies
  # a different parse Function, remember to always set the variable origin for a CompoundList
  parse: (response) ->
    parsed = @parseFromOrigin[@origin](response)
    return parsed;

  parseFromOrigin:
    # the original compound is to know which one is the one that is shown in the page
    'molecule_forms': (response) ->

      return response.molecule_forms









