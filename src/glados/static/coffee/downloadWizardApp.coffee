class DownloadWizardApp

  ### *
    * Initializes a menu item for the menu wizard.
    * return {WizardMenuItem}
  ###
  @initWizardStep = ->
    menuItem = new WizardStep

    menuItem.url = glados.Settings.GLADOS_BASE_URL_FULL+'download_wizard/first'

    return menuItem


  ### *
    * Initialises the first menu item for the first step of the wizard
  #
  ###
  @initBaseWizardStepView = (model, top_level_elem) ->

    baseWizardStepView = new WizardStepView
      model: model
      el: top_level_elem

    return baseWizardStepView