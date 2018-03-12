glados.useNameSpace 'glados.views.Breadcrumb',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @

    render: ->

      $breadcrumbsContainer = $(@el)
      breadcrumbsList = @model.get('breadcrumbs_list')
      glados.Utils.fillContentForElement $breadcrumbsContainer,
        breadcrumbs: breadcrumbsList

# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.views.Breadcrumb.BreadcrumbsView.getInstance = ->
  if not glados.views.Breadcrumb.BreadcrumbsView.__view_instance?
    glados.views.Breadcrumb.BreadcrumbsView.__view_instance = new glados.views.Breadcrumb.BreadcrumbsView
      el: $('#BCK-breadcrumbs')
      model: glados.models.Breadcrumb.BreadcrumbModel.getInstance()

  return glados.views.Breadcrumb.BreadcrumbsView.__view_instance
