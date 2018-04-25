glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      console.log "Init :)"
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @setUpResponsiveRender()
      @render()

    render: ->
      console.log 'Render :)'




