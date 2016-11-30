# View that renders the Document word cloud section
# from the Document report card
DocumentWordCloudView = CardView.extend(ResponsiviseViewExt).extend

  initialize: ->
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()
    @model.on 'change', updateViewProxy, @
    @resource_type = 'Document'
    @$vis_elem = $('#BCK-DocWordCloud')
    @firstTimeRender = true

  render: ->

    if @firstTimeRender
      @$vis_elem.html '<i class="fa fa-cog fa-spin fa-2x fa-fw" aria-hidden="true"></i><span class="sr-only">Loading Visualisation...</span><br>'
      @showCardContent()
      @firstTimeRender = false
      _.delay($.proxy(@render, @), Settings.RESPONSIVE_REPAINT_WAIT * 5)
      return

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
      wordCharNum = word.length
      value = wordVal[1]

      if value > highestValue
        highestValue = value
        highestValueWords = []
        highestValueWords.push word
        # I only care of the highest word size for the highest valued words
        highestWordLength = wordCharNum
      else if value == highestValue
        highestValueWords.push word
        if wordCharNum > highestWordLength
          highestWordLength = wordCharNum
      else
        lowestValue = value


    desiredPercentaje = 0.9
    desiredMaxWidth = desiredPercentaje * elemWidth
    # wordSize = fontSize * K * numChars
    # desiredMaxWidth = maxFontSize * K * highestWordLength
    # maxFontSize = desiredMaxWidth / (K * highestWordLength )
    maxFontSize = parseInt( desiredMaxWidth / (K * highestWordLength ) )
    minFontSize = 10

    getFontSizeFor = d3.scale.linear()
      .domain([lowestValue, highestValue])
      .range([minFontSize, maxFontSize])
      .clamp(true)

    #After having the font scale, I need to check that all the words fit the container, If not the scale needs to be adjusted.

    # to make sure that huge terms don't break the visualisation
    maxFontLimit = minFontSize * 2

    # used by the loop to know if the word overlaps the container
    itOverlaps = (wordVal) ->
      word = wordVal[0]
      value = wordVal[1]
      assignedFontSize = getFontSizeFor value
      numChars = word.length
      wordSize = assignedFontSize * K * numChars

      if wordSize > elemWidth * desiredPercentaje
        return true
      else return false

    for wordVal in wordList

      # if it overlaps, it reduces the maximum font size of the scale to its 90%
      # it repeats until it fits
      while itOverlaps(wordVal)
        currentRange = getFontSizeFor.range()
        minFont = currentRange[0]
        maxFontSize = 0.9 * maxFontSize
        if maxFontSize < maxFontLimit
          break
        getFontSizeFor.range([minFont, maxFontSize])
        console.log 'reset'

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
        return 'Score: ' +  getFontSizeFor.invert(Number(value)).toFixed(6)

      )
      .tooltip()
      .click( ->

        termEncoded = decodeURIComponent $(@).text()
        window.open('/documents_with_same_terms/' + termEncoded, '_blank')

      )




