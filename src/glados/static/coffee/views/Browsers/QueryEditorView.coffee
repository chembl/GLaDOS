glados.useNameSpace 'glados.views.Browsers',
  QueryEditorView: Backbone.View.extend

    initialize: ->

      @renderBaseStructure()
      @collection.on 'request', @updateRenderedQuery, @

    events:
      'click .BCK-toggle-query-container': 'toggleQueryContainer'

    codeStyles:
      RAW: 'Raw'
      CURL: 'cURL'

    renderBaseStructure: ->

      codeStyles = _.values(@codeStyles)
      glados.Utils.fillContentForElement $(@el),
        selected_code_style: codeStyles[0]
        code_styles: codeStyles[1..]

      $(@el).find('select').material_select()

    updateRenderedQuery: ->

      $queryContainer = $(@el).find('.BCK-query')
      latestRequest = @collection.getMeta('latest_request_data')
      latestRequestStr = JSON.stringify(latestRequest, null, 2)

      templateParams =
        index_name: @collection.getMeta('index_name')
        query: latestRequestStr
      glados.Utils.fillContentForElement($queryContainer, templateParams, customTemplate='Handlebars-Common-QueryEditor-Query')

      $toggleTrigger = $(@el).find('.BCK-toggle-query-container')
      @queryContainerOpen = $toggleTrigger.is(':visible')

    toggleQueryContainer: ->
      $(@el).find('.BCK-query-container').slideToggle()
      @queryContainerOpen = not @queryContainerOpen

      $toggleTrigger = $(@el).find('.BCK-toggle-query-container')
      if @queryContainerOpen
        $toggleTrigger.text('Hide Full Query')
      else
        $toggleTrigger.text('Show Full Query')






