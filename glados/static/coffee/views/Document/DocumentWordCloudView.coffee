# View that renders the Document word cloud section
# from the Document report card
DocumentWordCloudView = CardView.extend

  render: ->

    elemID = $(@el).attr('id')
    wordList = [['foo', 24], ['bar', 12]]

    WordCloud(document.getElementById(elemID), { list: wordList } );