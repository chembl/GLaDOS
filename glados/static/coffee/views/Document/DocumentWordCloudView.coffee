# View that renders the Document word cloud section
# from the Document report card
DocumentWordCloudView = CardView.extend(ResponsiviseViewExt).extend

  initialize: ->
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()
    @model.on 'change', @.render, @
    @resource_type = 'Document'
    @$vis_elem = $('#BCK-DocWordCloud')

  render: ->

    $description = $(@el).find('.card-description')
    $template = $('#' + $description.attr('data-hb-template'))
    $description.html Handlebars.compile( $template.html() )
      document_chembl_id: @model.get('document_chembl_id')

    @showCardContent()
    @initEmbedModal('word_cloud')
    @activateModals()
    @paintWordCloud()

  paintWordCloud: ->
    elemID = @$vis_elem.attr('id')
    elemWidth = @$vis_elem.width()
    @$vis_elem.height(elemWidth * 0.5)
    # wordSize = charSize * numChars
    # charSize = fontSize * K
    K = 0.54

    wordList = @model.get('word_list')

    # Get the domain and range for the scale, the biggest words should be 50% of the element width
    highestValueWords = []
    highestValue = 0
    highestWordLength = 0
    lowestValue = Number.MAX_VALUE

    for wordVal in wordList

      word = wordVal[0]
      wordSize = word.length
      value = wordVal[1]

      if value > highestValue
        highestValue = value
        highestValueWords = []
        highestValueWords.push word
        # I only care of the highest word size for the highest valued words
        highestWordLength = wordSize
      else if value == highestValue
        highestValueWords.push word
        if wordSize > highestWordLength
          highestWordLength = wordSize
      else
        lowestValue = value


    desiredMaxWidth = 0.8 * elemWidth
    # wordSize = fontSize * K * numChars
    # desiredMaxWidth = maxFontSize * K * highestWordLength
    # maxFontSize = desiredMaxWidth / (K * highestWordLength )
    maxFontSize = parseInt( desiredMaxWidth / (K * highestWordLength ) )
    minFontSize = 10

    getFontSizeFor = d3.scale.linear()
      .domain([lowestValue, highestValue])
      .range([minFontSize, maxFontSize])
      .clamp(true)

    getColourFor = d3.scale.linear()
      .domain([minFontSize, maxFontSize])
      .interpolate(d3.interpolateHcl)
      .range([d3.rgb(Settings.VISUALISATION_TEAL_MIN), d3.rgb(Settings.VISUALISATION_TEAL_MAX)])

    #rescale values
    for wordVal in wordList
      wordVal[1] = getFontSizeFor wordVal[1]

    wordIndex = _.indexBy(wordList, 0)

    config =
      list: wordList
      fontFamily: "Roboto Mono"
      drawOutOfBound: true
      color: (word, fontSize) ->
        getColourFor fontSize
      rotateRatio: 0.0
      classes: 'wordcloud-word'
      backgroundColor: Settings.VISUALISATION_CARD_GREY

    canvasElem = document.getElementById(elemID)
    WordCloud(canvasElem, config)

    $(canvasElem).on 'wordcloudstop', ->

      $(@).find('.wordcloud-word')
      .addClass('tooltiped')
      .attr('data-position', 'bottom')
      .attr('data-tooltip', ->
        text = $(@).text()
        value = wordIndex[text][1]
        return 'Score: ' +  Number(value).toFixed(2)

      )
      .tooltip()
      .click( ->

        termEncoded = decodeURIComponent $(@).text()
        window.open('/documents_with_same_terms/' + termEncoded, '_blank')

      )




