# View that takes care of handling the options in the
# download wizard.
WizardOptionView = Backbone.View.extend

  initialize: ->
    @render()

  render: ->

    template = @typeToTemplate[@model.get('type')]

    $(@el).html Handlebars.compile($(template).html())
      title: @model.get('title')
      link: @model.get('link')
      icon: @model.get('icon')
      description: @model.get('description')

  typeToTemplate:
    'icon': '#Handlebars-DownloadWizard-option-icon'
    'image': '#Handlebars-DownloadWizard-option-image'