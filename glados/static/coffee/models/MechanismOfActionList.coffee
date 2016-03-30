MechanismOfActionList = Backbone.Collection.extend
  model: MechanismOfAction
  parse: (response) ->
    console.log('getting mechanisms of action:')
    console.log(response)
    return response.mechanisms;
