glados.useNameSpace 'glados.views.Browsers',
  QueryEditorView: Backbone.View.extend

    initialize: ->

      @renderBaseStructure()
      @collection.on 'request', @updateRenderedQuery, @

    events:
      'click .BCK-toggle-query-container': 'toggleQueryContainer'
      'change .BCK-code-style-selector': 'selectCodeStyle'

    codeStyles:
      RAW: 'Raw'
      CURL: 'cURL'

    renderBaseStructure: ->

      codeStyles = _.values(@codeStyles)
      @selectedCodeStyle = codeStyles[0]
      glados.Utils.fillContentForElement $(@el),
        selected_code_style: @selectedCodeStyle
        code_styles: codeStyles[1..]

      $(@el).find('select').material_select()

    selectCodeStyle: (event) ->

      selectionValue = $(event.currentTarget).val()
      if selectionValue == ''
        return

      @selectedCodeStyle = selectionValue
      @updateRenderedQuery()

    updateRenderedQuery: ->

      console.log 'UPDATE RENDERED QUERY'

      $queryContainer = $(@el).find('.BCK-query')
      latestRequest = @collection.getMeta('latest_request_data')
      latestRequestStr = JSON.stringify(latestRequest, null, 2)

      if @selectedCodeStyle == @codeStyles.RAW
        console.log 'RAW'

        templateParams =
          index_name: @collection.getMeta('index_name')
          query: latestRequestStr
        glados.Utils.fillContentForElement($queryContainer, templateParams,
          customTemplate='Handlebars-Common-QueryEditor-Query')

        $queryContainer = $(@el).find('.BCK-toggle-query-container')
        @queryContainerOpen = $queryContainer.is(':visible')
      else

        templateParams =
          url: @collection.getURL()
          query: latestRequestStr

        glados.Utils.fillContentForElement($queryContainer, templateParams,
          customTemplate='Handlebars-Common-QueryEditor-CURL')
        console.log 'CURL'


    toggleQueryContainer: ->
      $(@el).find('.BCK-query-container').slideToggle()
      @queryContainerOpen = not @queryContainerOpen

      $toggleTrigger = $(@el).find('.BCK-toggle-query-container')
      if @queryContainerOpen
        $toggleTrigger.text('Hide Full Query')
      else
        $toggleTrigger.text('Show Full Query')






