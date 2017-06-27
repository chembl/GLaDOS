glados.useNameSpace 'glados.views.MainPage',
  DatabaseSummaryView: Backbone.View.extend

    initialize: ->
      @model.on 'change', @render, @

    render: ->
      console.log 'RENDER DATABASE SUMMARY'

      $contentElement = $(@el).find('.BCK-content')
      glados.Utils.fillContentForElement $contentElement,
        chembl_db_version: @model.get('chembl_db_version')
        chembl_release_date: @model.get('chembl_release_date')
        num_targets: $.number(@model.get('num_targets'))
        num_compound_records: $.number(@model.get('num_compound_records'))
        num_compounds: $.number(@model.get('num_compounds'))

      console.log "@model.get('chembl_db_version')", @model.get('chembl_db_version')
      console.log @model

      @showContent()

    showContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.BCK-content').show()


