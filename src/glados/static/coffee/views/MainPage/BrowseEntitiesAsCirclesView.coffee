glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      console.log "Init :)"
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @setUpResponsiveRender()
      @render()

    render: ->
      console.log 'Render :)'

      entities_info =
        compounds: 0
        drugs: 0
        documents: 0
        targets: 0
        assays: 0
        cells: 0
        tissues: 0

      console.log 'entities_info: ', entities_info





