# View that renders the Assay basic information section
# from the Assar report card
# load CardView first!
# also make sure the html can access the handlebars templates!
AssayBasicInformationView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @

  render: ->

    console.log('render!')