# View that renders the Document word cloud section
# from the Document report card
DocumentWordCloudView = CardView.extend(ResponsiviseViewExt).extend

  initialize: ->
    #ResponsiviseViewExt
    updateViewProxy = @setUpResponsiveRender()

  render: ->

    elemID = $(@el).attr('id')
    $(@el).height($(@el).width())
    # TODO: use a scale to adjust the values depending on a screen size
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
      ['7-[4-(methylthio)-benzoyl]benzofuran-5-ylacetic', 96]
      ['Aspirin', 24]
      ['Mouse', 96]
      ['Virtually', 12]
      ['Gastric', 96]
      ['Ulceration', 96]


    ]

    WordCloud(document.getElementById(elemID), { list: wordList } );