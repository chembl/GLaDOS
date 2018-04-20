glados.useNameSpace 'glados.views.MainPage',
  DatabaseSummaryView: Backbone.View.extend

    initialize: ->
      @model.on 'change', @render, @
      @model.on 'error', @renderError, @

    render: ->

      chemblDBVersion = @model.get('chembl_db_version')

      if chemblDBVersion?
        releaseNotesLink = 'ftp://ftp.ebi.ac.uk/pub/databases/chembl/ChEMBLdb/releases/' + chemblDBVersion.toLowerCase()
        + '/' + chemblDBVersion.toLowerCase() + '_release_notes.txt'
      else
        releaseNotesLink = '#'

      $contentElement = $(@el).find('.BCK-content')
      glados.Utils.fillContentForElement $contentElement,
        chembl_db_version: chemblDBVersion.replace('_', ' ')
        chembl_release_date: @model.get('chembl_release_date')
        num_targets: $.number(@model.get('targets'))
        num_compound_records: $.number(@model.get('compound_records'))
        num_compounds: $.number(@model.get('disinct_compounds'))
        num_activities: $.number(@model.get('activities'))
        num_publications: $.number(@model.get('publications'))
        num_datasets: glados.views.MainPage.DatabaseSummaryView.LOADING_LABEL
        release_notes_link: releaseNotesLink

      @showContent()
      @fetchDatasets()

    showContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.BCK-content').show()

    renderError: ->
      $contentElement = $(@el).find('.BCK-content')
      glados.Utils.ErrorMessages.fillErrorForElement($contentElement)
      @showContent()

    fetchDatasets: ->
      databaseInfoEsURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}jijijiu"
      fetchDatabasePromise = $.get(databaseInfoEsURL)

      thisView = @
      fetchDatabasePromise.fail ->

        $container = $(thisView.el).find('.BCK-num-datasets')
        $container.text(glados.views.MainPage.DatabaseSummaryView.ERROR_LABEL)





glados.views.MainPage.DatabaseSummaryView.LOADING_LABEL = 'LOADING...'
glados.views.MainPage.DatabaseSummaryView.ERROR_LABEL = 'ERROR :('