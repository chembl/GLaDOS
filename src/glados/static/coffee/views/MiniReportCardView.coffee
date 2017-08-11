glados.useNameSpace 'glados.views',
  MiniReportCardView: Backbone.View.extend

    initialize: ->
      @entity = arguments[0].entity
      @customTemplate = arguments[0].custom_template
      @model.on 'change', @render, @
      @model.on 'error', @renderError, @
      templateCont = $('#' + Compound.MINI_REPORT_CARD.LOADING_TEMPLATE).html()
      $(@el).html Handlebars.compile(templateCont)

    render: ->

      templateID = @customTemplate
      templateID ?= @entity.MINI_REPORT_CARD.TEMPLATE
      templateCont = $('#' + templateID).html()
      valuesObject = glados.Utils.getColumnsWithValues(@entity.MINI_REPORT_CARD.COLUMNS, @model)
      imgUrl = glados.Utils.getImgURL(valuesObject)
      $(@el).html Handlebars.compile(templateCont)
        img_url: imgUrl
        columns: valuesObject

    renderError:  (model_or_collection, jqXHR, options) ->
      $(@el).html glados.Utils.ErrorMessages.getErrorCardContent(jqXHR)
