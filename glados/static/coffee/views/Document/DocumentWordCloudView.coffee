# View that renders the Document word cloud section
# from the Document report card
DocumentWordCloudView = CardView.extend(ResponsiviseViewExt).extend

  initialize: ->
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()

  render: ->

    elemID = $(@el).attr('id')
    elemWidth = $(@el).width()
    $(@el).height(elemWidth)
    # wordSize = charSize * numChars
    # charSize = fontSize * K
    K = 0.54

    wordList = [
      ['Number', 24]
      ['7-benzoylbenzofuran-5-ylacetic', 24]
      ['Acid', 48]
      ['Synthesize', 24]
      ['Potent', 24]
      ['Phenylbutazone', 24]
      ['Rat', 48]
      ['Paw', 48]
      ['Antiinflammatory', 24]
      ['Edema', 24]
      ['Assay', 48]
      ['analgetic', 24]
      ['compound', 12]
      ['7-[4-(methylthio)-benzoyl]benzofuran-5-ylacetic', 24]
      ['Aspirin', 24]
      ['Mouse', 96]
      ['Virtually', 12]
      ['Gastric', 96]
      ['Ulceration', 96]


    ]

    # Get the domain and range for the scale, the biggest words should be 50% of the element width
    highestValueWords = []
    highestValue = 0
    highestWordLength = 0

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


    desiredMaxWidth = 0.5 * elemWidth
    # wordSize = fontSize * K * numChars
    # desiredMaxWidth = maxFontSize * K * highestWordLength
    # maxFontSize = desiredMaxWidth / (K * highestWordLength )
    maxFontSize = parseInt( desiredMaxWidth / (K * highestWordLength ) )

    getFontSizeFor = d3.scale.linear()
      .domain([0, highestValue])
      .range([10, maxFontSize])
      .clamp(true)

    #rescale values
    for wordVal in wordList
      wordVal[1] = getFontSizeFor wordVal[1]

    console.log wordList



    WordCloud(document.getElementById(elemID), { list: wordList, fontFamily: "Roboto Mono", drawOutOfBound: true } );