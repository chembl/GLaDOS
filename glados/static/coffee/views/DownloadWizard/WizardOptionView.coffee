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
      image: @model.get('image')
      description: @model.get('description')
      db_menu_option_default: 'db-menu-option-default' unless @model.get('is_default') == 'no'

  typeToTemplate:
    'icon': '#Handlebars-DownloadWizard-option-icon'
    'image': '#Handlebars-DownloadWizard-option-image'