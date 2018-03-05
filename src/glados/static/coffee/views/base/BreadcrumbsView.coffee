glados.useNameSpace 'glados.views.base',
  BreadcrumbsView: Backbone.View.extend
    initialize: ->
      @el = arguments[0].el
      @model = arguments[0].model
      @model.on 'change', @render
      @breadcrumbs = @model.breadcrumbs_list
      @render()

    render: ->
      glados.Utils.fillContentForElement $(@el), breadcrumbs: @breadcrumbs, 'Handlebars-BreadcrumbsContent'
