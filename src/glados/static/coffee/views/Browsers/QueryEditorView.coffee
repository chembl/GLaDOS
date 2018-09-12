glados.useNameSpace 'glados.views.Browsers',
  QueryEditorView: Backbone.View.extend

    initialize: ->

      @renderBaseStructure()
      @collection.on 'request', @updateRenderedQuery, @

    renderBaseStructure: -> glados.Utils.fillContentForElement($(@el))

    updateRenderedQuery: ->

      $queryContainer = $(@el).find('.BCK-query-container')
      latestRequest = @collection.getMeta('latest_request_data')
      latestRequestStr = JSON.stringify(latestRequest, null, 2)

      templateParams =
        query: latestRequestStr
      glados.Utils.fillContentForElement($queryContainer, templateParams, customTemplate='Handlebars-Common-QueryEditor-Query')


