# View that takes care of handling the interaction of the user in the
# download wizard.
WizardStepView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    @render()

  render: ->

    console.log(@model.get('title'))
    $(this.el).html Handlebars.compile($('#Handlebars-DownloadWizard-step').html())
      title: @model.get('title')
      options: @model.get('options')
      right_option: @model.get('right_option')