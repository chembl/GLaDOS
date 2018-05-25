# View that takes care of handling the interaction of the user in the
# download wizard.
WizardStepView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showErrorMsg, @
    @setPreloader()

  events:
    "click .db-menu-link": "goToStep"
    "mouseover .db-menu-option": "handleHover"

  render: ->

    @hidePreloader()
    template = @typeToTemplate[@model.get('type')]
    $(this.el).html Handlebars.compile($(template).html())
      title: @model.get('title')
      description: @model.get('description')
      previous_step: @model.get('previous_step')
      hide_previous_step: !@model.get('previous_step')?
      right_option: @model.get('right_option')
      hide_right_option: !@model.get('right_option')?
      left_option: @model.get('left_option')
      hide_left_option: !@model.get('left_option')?
      license: @model.get('license')

    for option in @model.get('options')
      bckOption = new WizardOption
        title: option.title
        description: option.description
        link: option.link
        icon: option.icon
        data_icon: option.data_icon
        type: option.type
        image: option.image
        is_default: option.is_default

      newElement = $('<div>')
      wizardOprionView = new WizardOptionView
        model: bckOption
        el: newElement

      $(@el).find('.db-menu-option-container').append(newElement)

  goToStep: (event) ->

    @setPreloader()
    next_url = glados.Settings.GLADOS_BASE_URL_FULL+\
      '/download_wizard/' + $(event.currentTarget).attr('href').substring(1)
    @model.url = next_url
    @model.fetch()

  handleHover: (event) ->
    desc = $(event.currentTarget).attr('data-description')
    $(@el).find('.db-menu-option-description').text(desc)

  showDescription: ->
    console.log('showing desc')

  hidePreloader: ->
    $(@el).find('.card-preolader-to-hide').hide()

  setPreloader: ->
    $(this.el).html Handlebars.compile($('#Handlebars-Common-Preloader').html())

  showErrorMsg: ->

    $(this.el).html Handlebars.compile($('#Handlebars-DownloadWizard-error').html())
      msg: 'There was an error loading the next step'

  typeToTemplate:
    'normal': '#Handlebars-DownloadWizard-step'
    'lic_agreement': '#Handlebars-DownloadWizard-step-licag'




