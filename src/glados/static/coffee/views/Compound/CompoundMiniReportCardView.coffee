CompoundMiniReportCardView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    templateCont = $('#' + Compound.MINI_REPORT_CARD.LOADING_TEMPLATE).html()
    $(@el).html Handlebars.compile(templateCont)()

  render: ->

    console.log 'LOADED!'
    $(@el).html 'loaded!'



