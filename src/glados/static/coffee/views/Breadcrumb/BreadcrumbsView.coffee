glados.useNameSpace 'glados.views.Breadcrumb',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @
      @hideFilterMenu()

    render: ->

      $breadcrumbsContainer = $(@el).find('.BCK-dynamic-breadcrumbs')
      breadcrumbsList = @model.get('breadcrumbs_list')
      glados.Utils.fillContentForElement $breadcrumbsContainer,
        breadcrumbs: breadcrumbsList

      @hideFilterMenu()

    events:
      'click .BCK-open-filter-explain': 'toggleFilterMenu'

    toggleFilterMenu: -> $(@el).find('.BCK-filter-explain').slideToggle()
    openFilterMenu: -> $(@el).find('.BCK-filter-explain').show()
    hideFilterMenu: -> $(@el).find('.BCK-filter-explain').hide()

# ----------------------------------------------------------------------------------------------------------------------
# Singleton
# ----------------------------------------------------------------------------------------------------------------------
glados.views.Breadcrumb.BreadcrumbsView.getInstance = ->
  if not glados.views.Breadcrumb.BreadcrumbsView.__view_instance?
    $breadcrumbsContainer = $('#BCK-breadcrumbs')
    glados.apps.Main.MainGladosApp.setUpLinkShortenerListener($breadcrumbsContainer[0])
    glados.views.Breadcrumb.BreadcrumbsView.__view_instance = new glados.views.Breadcrumb.BreadcrumbsView
      el: $breadcrumbsContainer
      model: glados.models.Breadcrumb.BreadcrumbModel.getInstance()

  return glados.views.Breadcrumb.BreadcrumbsView.__view_instance
