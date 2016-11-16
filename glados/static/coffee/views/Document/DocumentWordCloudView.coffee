# View that renders the Document word cloud section
# from the Document report card
DocumentWordCloudView = CardView.extend(ResponsiviseViewExt).extend

  initialize: ->
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()

    @model.on 'change', @.render, @

  render: ->

    elemID = $(@el).attr('id')
    elemWidth = $(@el).width()
    $(@el).height(elemWidth)
    # wordSize = charSize * numChars
    # charSize = fontSize * K
    K = 0.54

    wordList = @model.get('word_list')
    console.log 'original list:'
    console.log JSON.stringify(wordList)
#    wordList = [
#      ['Number', 24/1000]
#      ['7-benzoylbenzofuran-5-ylacetic', 24/1000]
#      ['Acid', 48/1000]
#      ['Synthesize', 24/1000]
#      ['Potent', 24/1000]
#      ['Phenylbutazone', 24/1000]
#      ['Rat', 48/1000]
#      ['Paw', 48/1000]
#      ['Antiinflammatory', 24/1000]
#      ['Edema', 24/1000]
#      ['Assay', 48/1000]
#      ['analgetic', 24/1000]
#      ['compound', 12/1000]
#      ['7-[4-(methylthio)-benzoyl]benzofuran-5-ylacetic', 24/1000]
#      ['Aspirin', 24/1000]
#      ['Mouse', 96/1000]
#      ['Virtually', 12/1000]
#      ['Gastric', 96/1000]
#      ['Ulceration', 96/1000]
#
#
#    ]

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
      .range([d3.rgb(Settings.VISUALISATION_RED_MIN), d3.rgb(Settings.VISUALISATION_RED_MAX)])

    #rescale values
    for wordVal in wordList
      wordVal[1] = getFontSizeFor wordVal[1]

    console.log wordList

    config =
      list: wordList
      fontFamily: "Roboto Mono"
      drawOutOfBound: true
      color: (word, fontSize) ->
        getColourFor fontSize
      rotateRatio: 0.0


    WordCloud(document.getElementById(elemID), config);