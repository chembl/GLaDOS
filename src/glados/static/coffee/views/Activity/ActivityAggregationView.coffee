glados.useNameSpace 'glados.views.Activity',
  ActivityAggregationView: Backbone.View.extend

    initialize: -> @render()

    render: ->
      templateID = glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD.TEMPLATE
      valuesObject = glados.Utils.getColumnsWithValues(\
        glados.models.Activity.ActivityAggregation.MINI_REPORT_CARD.COLUMNS, @model)

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