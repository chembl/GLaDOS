CompoundMiniReportCardView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    templateCont = $('#' + Compound.MINI_REPORT_CARD.LOADING_TEMPLATE).html()
    $(@el).html Handlebars.compile(templateCont)()

  render: ->

    templateCont = $('#' + Compound.MINI_REPORT_CARD.TEMPLATE).html()
    valuesObject = glados.Utils.getColumnsWithValues(Compound.MINI_REPORT_CARD.COLUMNS, @model)
    imgUrl = glados.Utils.getImgURL(valuesObject)
    $(@el).html Handlebars.compile(templateCont)
      img_url: imgUrl
      columns: valuesObject



