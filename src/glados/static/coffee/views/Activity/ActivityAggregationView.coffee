glados.useNameSpace 'glados.views.Activity',
  ActivityAggregationView: Backbone.View.extend

    initialize: -> @render()

    render: ->
      templateID = glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD.TEMPLATE
      [valuesObject, highlights] = glados.Utils.getColumnsWithValuesAndHighlights(\
        glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD.COLUMNS, @model)

      console.log 'AAA valuesObject: ', valuesObject
      filter = 'target_chembl_id:("' + @model.get('target_chembl_id') +
        '") AND molecule_chembl_id:("' + @model.get('molecule_chembl_id') + '")'

      linkURL = Activity.getActivitiesListURL(filter)
      glados.Utils.fillContentForElement($(@el),
        {
          columns: valuesObject
          general_link_url: linkURL
          general_link_text: 'See all activities'
        },
        templateID)