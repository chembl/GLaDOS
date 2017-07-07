glados.useNameSpace 'glados.views',
  MiniReportCardView: Backbone.View.extend

    initialize: ->
      @entity = arguments[0].entity
      @model.on 'change', @.render, @
      templateCont = $('#' + Compound.MINI_REPORT_CARD.LOADING_TEMPLATE).html()
      $(@el).html Handlebars.compile(templateCont)

    render: ->

      templateCont = $('#' + @entity.MINI_REPORT_CARD.TEMPLATE).html()
      valuesObject = glados.Utils.getColumnsWithValues(@entity.MINI_REPORT_CARD.COLUMNS, @model)
      imgUrl = glados.Utils.getImgURL(valuesObject)
      $(@el).html Handlebars.compile(templateCont)
        img_url: imgUrl
        columns: valuesObject