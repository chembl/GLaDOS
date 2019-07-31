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


      indexName = @model.indexName

      propertiesGroup = @config.properties_group

      propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
        index_name: indexName
        group_name: propertiesGroup

      thisView = @
      propertiesConfigModel.on('error', @showCompoundErrorCard)
      propertiesConfigModel.on('change:parsed_configuration', ->

        propertiesToShow = propertiesConfigModel.get('parsed_configuration').Default

        [columnsWithValues, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(propertiesToShow,
          thisView.model)
        protertiesWithValuesIndex = _.indexBy(columnsWithValues, 'template_id')

        if thisView.config.sort_alpha

          for property in propertiesToShow

            if property.id == thisView.config.property_id_to_sort
              valueNames = protertiesWithValuesIndex[property.id].value
              valueNames.sort()
              protertiesWithValuesIndex[property.id].value = valueNames

        $containerElem = $(thisView.el).find('.BCK-Details-Container')
        glados.Utils.fillContentForElement $containerElem, protertiesWithValuesIndex

        thisView.showSection()
        thisView.showCardContent()

        thisView.config.after_render(thisView) unless not thisView.config.after_render?

      )
      propertiesConfigModel.fetch()

