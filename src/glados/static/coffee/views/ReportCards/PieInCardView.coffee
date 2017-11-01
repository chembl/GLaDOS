glados.useNameSpace 'glados.views.ReportCards',
  PieInCardView: CardView.extend

    initialize: ->

      @config = arguments[0].config
      @model.on 'change', @render, @
      @resource_type = @config.resource_type

      @paginatedView = new PieView
        model: @model
        el: $(@el).find('.BCK-Main-Pie-container')
        config: @config.pie_config

      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()

    render: ->

      @showCardContent()

      if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE or \
      @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        return

      $linkToActivities = $(@el).find('.BCK-all-sources-link')
      glados.Utils.fillContentForElement $linkToActivities,
        link_text: @config.link_to_all.link_text
        url: @config.link_to_all.url


