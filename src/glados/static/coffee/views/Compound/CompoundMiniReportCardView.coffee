CompoundMiniReportCardView = Backbone.View.extend

  LOADING_TEMPLATE: 'Handlebars-Common-MiniRepCardPreloader'
  initialize: ->

    $(@el).html Handlebars.compile($('#' + @LOADING_TEMPLATE).html())()