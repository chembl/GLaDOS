glados.useNameSpace 'glados.views.MainPage',
  BrowseEntitiesAsCirclesView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      console.log "Init :)"
      @$vis_elem = $(@el).find('.BCK-circles-Container')
      @model.on 'change', @render, @
      @setUpResponsiveRender()
      @render()

    render: ->
      console.log 'Render :)'

      entities_info =
        compounds: $.number(@model.get('disinct_compounds'))
        drugs: 0
        documents: $.number(@model.get('publications'))
        targets: $.number(@model.get('targets'))
        assays: 0
        cells: 0
        tissues: 0

      console.log 'entities_info: ', entities_info





