#this is intended to represent everything after the # in the url
glados.useNameSpace 'glados.models.URL',
  URLModel: Backbone.Model.extend
    initialize: ->

# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.models.URL.URLModel.getInstance = ->
  if not glados.models.URL.URLModel.__model_instance?
    glados.models.URL.URLModel.__model_instance = new glados.models.URL.URLModel
  return glados.models.URL.URLModel.__model_instance