// Generated by CoffeeScript 1.4.0
var MechanismOfActionList;

MechanismOfActionList = Backbone.Collection.extend({
  model: MechanismOfAction,
  parse: function(response) {
    console.log('getting mechanisms of action:');
    console.log(response);
    return response.mechanisms;
  }
});
