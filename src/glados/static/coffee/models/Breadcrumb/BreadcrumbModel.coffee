glados.useNameSpace 'glados.models.Breadcrumb',
  BreadcrumbModel: Backbone.Model.extend
    initialize: ->

# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.models.Breadcrumb.BreadcrumbModel.getInstance = ->
  if not glados.models.Breadcrumb.BreadcrumbModel.__model_instance?
    glados.models.Breadcrumb.BreadcrumbModel.__model_instance = new glados.models.Breadcrumb.BreadcrumbModel
  return glados.models.Breadcrumb.BreadcrumbModel.__model_instance