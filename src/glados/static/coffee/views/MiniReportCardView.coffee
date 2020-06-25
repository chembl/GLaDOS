glados.useNameSpace 'glados.views',
  MiniReportCardView: Backbone.View.extend

    initialize: ->
      @entity = arguments[0].entity
      @customTemplate = arguments[0].custom_template
      @additional_params = arguments[0].additional_params
      @customColumns = arguments[0].custom_columns

      @model.on 'change', @render, @
      @model.on 'error', @renderError, @
      templateCont = $('#' + Compound.MINI_REPORT_CARD.LOADING_TEMPLATE).html()
      $(@el).html Handlebars.compile(templateCont)

    render: ->

      templateID = @customTemplate
      templateID ?= @entity.MINI_REPORT_CARD.TEMPLATE
      templateCont = $('#' + templateID).html()

      columns = @customColumns
      columns ?= @entity.MINI_REPORT_CARD.COLUMNS

      indexName = @entity.ES_INDEX
      groupName = 'browser_table'

      propertiesConfigModel = new glados.models.paginatedCollections.esSchema.PropertiesConfigurationModel
        index_name: indexName
        group_name: groupName

      thisView = @
      propertiesConfigModel.on('error', @renderError)
      propertiesConfigModel.on('change:parsed_configuration', ->
        columns = propertiesConfigModel.get('parsed_configuration').Default

        [valuesObject, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(columns, thisView.model)
        imgUrl = glados.Utils.getImgURL(valuesObject)

        paramsObj =
          img_url: imgUrl
          columns: valuesObject

        _.extend(paramsObj, thisView.additional_params)
        $(thisView.el).html(Handlebars.compile(templateCont)(paramsObj))

      )
      propertiesConfigModel.fetch()

    renderError:  (model_or_collection, jqXHR, options) ->
      $(@el).html glados.Utils.ErrorMessages.getErrorCardContent(jqXHR)
