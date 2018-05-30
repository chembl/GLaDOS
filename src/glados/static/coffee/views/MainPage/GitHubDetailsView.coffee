glados.useNameSpace 'glados.views.MainPage',
  GitHubDetailsView: Backbone.View.extend

    initialize: ->
      thisView = @
      infoURL = "#{glados.Settings.GLADOS_BASE_PATH_REL}github_details"

      fetchDatabasePromise = $.getJSON(infoURL)

      fetchDatabasePromise.fail ->
        console.log 'Fetching github details failed :('

      fetchDatabasePromise.done (response) ->
        thisView.render(response)

    render: (response) ->
      console.log 'render: ', response

      glados.Utils.fillContentForElement $(@el),
        time_ago : response.time_ago
        message : response.message
        commit_url : response.url





