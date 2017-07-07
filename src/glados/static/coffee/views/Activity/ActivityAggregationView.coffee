glados.useNameSpace 'glados.views.Activity',
  ActivityAggregationView: Backbone.View.extend

    initialize: -> @render()

    render: ->
      templateID = glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD.TEMPLATE
      valuesObject = glados.Utils.getColumnsWithValues(\
        glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD.COLUMNS, @model)

      general_link = 'hola'
      glados.Utils.fillContentForElement($(@el),
        {
          columns: valuesObject
          general_link: general_link
        },
        templateID)