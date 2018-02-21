glados.useNameSpace 'glados.views.ReportCards',
  VisualisationInCardView: CardView.extend

    initialize: ->


      @config = arguments[0].config
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @

      @resource_type = @config.resource_type
      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

      console.log 'INIT VIS IN CARD!!!'
      console.log 'model: ', @model
      ViewClass = @config.view_class


    render: ->

      console.log 'RENDER VIS IN CARD!!!'
      @showCardContent()