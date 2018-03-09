glados.useNameSpace 'glados.views.Breadcrumb',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render
      @breadcrumbs = @model.breadcrumbs_list
      @render()

    render: ->
      glados.Utils.fillContentForElement $(@el), breadcrumbs: @breadcrumbs, 'Handlebars-BreadcrumbsContent'

# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.views.Breadcrumb.BreadcrumbsView.getInstance = ->
  if not glados.views.Breadcrumb.BreadcrumbsView.__view_instance?
    glados.views.Breadcrumb.BreadcrumbsView.__view_instance = new glados.models.Breadcrumb.BreadcrumbModel
      el: $('#BCK-breadcrumbs')
      model: glados.models.Breadcrumb.BreadcrumbModel.getInstance()

  return glados.views.Breadcrumb.BreadcrumbsView.__view_instance
