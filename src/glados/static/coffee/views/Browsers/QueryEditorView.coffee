glados.useNameSpace 'glados.views.Browsers',
  QueryEditorView: Backbone.View.extend

    initialize: ->

      @renderBaseStructure()
      @collection.on 'request', @updateRenderedQuery, @

    events:
      'click .BCK-toggle-query-container': 'toggleQueryContainer'
      'click .BCK-toggle-queryStringEditor': 'toggleQuerystringEditor'
      'change .BCK-code-style-selector': 'selectCodeStyle'

    codeStyles:
      CURL: 'cURL'
      RAW: 'Raw'

    renderBaseStructure: ->

      codeStyles = _.values(@codeStyles)
      @selectedCodeStyle = codeStyles[0]
      glados.Utils.fillContentForElement $(@el),
        selected_code_style: @selectedCodeStyle
        code_styles: codeStyles[1..]

      $queryContainer = $(@el).find('.BCK-toggle-query-container')
      @queryContainerOpen = $queryContainer.hasClass('open')

      $queryEditorContainer = $(@el).find('.BCK-querystring-container')
      @queryStringEditorOpen = $queryEditorContainer.hasClass('open')

      $(@el).find('select').material_select()
      $copyButtonContainer = $(@el).find('.BCK-copy-button')
      @$copyButton = ButtonsHelper.createAndAppendCopyButton($copyButtonContainer)

    selectCodeStyle: (event) ->

      selectionValue = $(event.currentTarget).val()
      if selectionValue == ''
        return

      @selectedCodeStyle = selectionValue
      @updateRenderedQuery()

    updateQueryString: ->


    updateRenderedQuery: ->

      $queryContainer = $(@el).find('.BCK-query')
      latestRequest = @collection.getMeta('latest_request_data')
      latestRequestStr = JSON.stringify(latestRequest, null, 2)

      if @selectedCodeStyle == @codeStyles.RAW

        indexName = @collection.getMeta('index_name')
        templateParams =
          index_name: @collection.getMeta('index_name')
          query: latestRequestStr

        textToCopy = "Index Name: #{indexName}\nQuery:\n#{latestRequestStr}"
        glados.Utils.fillContentForElement($queryContainer, templateParams,
          customTemplate='Handlebars-Common-QueryEditor-Query')

      else

        templateParams =
          url: @collection.getURL()
          query: latestRequestStr

        glados.Utils.fillContentForElement($queryContainer, templateParams,
          customTemplate='Handlebars-Common-QueryEditor-CURL')

        textToCopy = $queryContainer.find('pre').text()

      ButtonsHelper.updateCopyDataOfButton(@$copyButton, textToCopy)

    toggleQuerystringEditor: ->

      $container = $(@el).find('.BCK-querystring-container')
      $toggler = $(@el).find('.BCK-toggle-queryStringEditor')
      @queryStringEditorOpen = not @queryStringEditorOpen
      @toggleContainer($container, @queryStringEditorOpen, 'Hide Querystring', 'Edit Querystring', $toggler)

    toggleQueryContainer: ->

      $container = $(@el).find('.BCK-query-container')
      $toggler = $(@el).find('.BCK-toggle-query-container')
      @queryContainerOpen = not @queryContainerOpen
      @toggleContainer($container, @queryContainerOpen, 'Hide Full Query', 'Show Full Query', $toggler)

    toggleContainer: ($container, isNowOpen, hideText, showText, $toggler) ->

      if isNowOpen
        $container.removeClass('closed')
        $container.addClass('open')
        $toggler.text(hideText)
      else
        $container.removeClass('open')
        $container.addClass('closed')
        $toggler.text(showText)






