# View that renders the Document basic information section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentBasicInformationView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @

  render: ->

    console.log('render!')