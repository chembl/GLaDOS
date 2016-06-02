class DownloadWizardApp

  ### *
    * Initializes a menu item for the menu wizard.
    * return {WizardMenuItem}
  ###
  @initWizardStep = ->
    menuItem = new WizardStep
      title: 'Downloads'
      options: [
        {title:'SQL Data', icon:'fa-database', description: 'Download our sql data.'},
        {title:'Virtual Environments', icon:'fa-cubes', description: 'ChEMBL Virtual Machines.'},
        {title:'RDF', icon:'fa-sitemap', description: 'Download the ChEMBL-RDF.'},
        {title:'UniChem', icon:'fa-smile-o', description: 'Data dumps from UniChem.'},
        {title:'Patents', icon:'fa-book', description: 'Patent compound exports.'},
        {title:'Monomers', icon:'fa-smile-o', description: 'Monomers.'},
        {title:'Monomers', icon:'fa-smile-o', description: 'Monomers.'},
      ]
      right_option: 'More...'

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