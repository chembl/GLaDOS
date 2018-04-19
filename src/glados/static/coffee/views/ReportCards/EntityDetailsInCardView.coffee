glados.useNameSpace 'glados.views.ReportCards',
  EntityDetailsInCardView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @config = arguments[0].config
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'
      @initEmbedModal(@config.embed_section_name, @config.embed_identifier)
      @activateModals()
      
    render: ->
      show = @config.show_if(@model)
      if not show
        @hideSection()
        return
      propertiesToShow = @config.properties_to_show
      [columnsWithValues, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(propertiesToShow, @model)
      protertiesWithValuesIndex = _.indexBy(columnsWithValues, 'template_id')

      if @config.sort_alpha

        for property in propertiesToShow

          if property.id = @config.property_id_to_sort
            valueNames = protertiesWithValuesIndex[property.id].value
            valueNames.sort()
            protertiesWithValuesIndex[property.id].value = valueNames

      $containerElem = $(@el).find('.BCK-Details-Container')
      glados.Utils.fillContentForElement $containerElem, protertiesWithValuesIndex

      @showSection()
      @showCardContent()

      @config.after_render(@) unless not @config.after_render?


