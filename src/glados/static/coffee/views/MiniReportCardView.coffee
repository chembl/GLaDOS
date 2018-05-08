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

      console.log 'RENDER MINI REPORT CARD: '
      templateID = @customTemplate
      templateID ?= @entity.MINI_REPORT_CARD.TEMPLATE
      templateCont = $('#' + templateID).html()

      columns = @customColumns
      columns ?= @entity.MINI_REPORT_CARD.COLUMNS
      [valuesObject, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(columns, @model)
      imgUrl = glados.Utils.getImgURL(valuesObject)

      paramsObj =
        img_url: imgUrl
        columns: valuesObject

      _.extend(paramsObj, @additional_params)
      $(@el).html Handlebars.compile(templateCont)(paramsObj)

    renderError:  (model_or_collection, jqXHR, options) ->
      $(@el).html glados.Utils.ErrorMessages.getErrorCardContent(jqXHR)
