glados.useNameSpace 'glados.views.MainPage',
  GitHubDetailsView: Backbone.View.extend

    initialize: ->
        @render()

    render: ->
      infoURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}github_details"

      fetchDatabasePromise = $.getJSON(infoURL)

      fetchDatabasePromise.fail ->
        console.log 'Fetching github details failed :('

      fetchDatabasePromise.done (response) ->

        time_ago = response.time_ago
        message = response.message
        commit_url = response.url

        console.log message, time_ago, commit_url
#        fillContentForElement(el, response)


