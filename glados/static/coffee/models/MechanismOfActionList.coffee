MechanismOfActionList = Backbone.Collection.extend
  model: MechanismOfAction
  parse: (response) ->
    return response.mechanisms;
