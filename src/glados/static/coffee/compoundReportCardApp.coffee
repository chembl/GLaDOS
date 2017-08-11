# This takes care of handling the compound report card.
class CompoundReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    compound = new Compound({molecule_chembl_id: GlobalVariables.CHEMBL_ID})
    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + GlobalVariables.CHEMBL_ID
    moleculeFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAlternateFormsListForCarousel()
    moleculeFormsList.initURL GlobalVariables.CHEMBL_ID
    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL GlobalVariables.CHEMBL_ID, glados.Settings.DEFAULT_SIMILARITY_THRESHOLD
    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL+'testData/metabolismSampleData.json'

    new CompoundNameClassificationView
      model: compound
      el: $('#CNCCard')

    new CompoundImageView
        model: compound
        el: ('#CNCImageCard')

    new CompoundRepresentationsView
        model: compound
        el: $('#CompRepsCard')

    new CompoundCalculatedParentPropertiesView
        model: compound
        el: $('#CalculatedParentPropertiesCard')

    new CompoundMechanismsOfActionView
        collection: mechanismOfActionList
        el: $('#MechOfActCard')

    new CompoundFeaturesView
        model: compound
        el: $('#MoleculeFeaturesCard')

    new CompoundMoleculeFormsListView
        collection: moleculeFormsList
        el: $('#AlternateFormsCard')

    new SimilarCompoundsView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')

    new CompoundMetabolismView
      model: compoundMetabolism
      el: $('#MetabolismCard')

    compound.fetch()
    mechanismOfActionList.fetch({reset: true})
    moleculeFormsList.fetch({reset: true})
    similarCompoundsList.fetch({reset: true})
    compoundMetabolism.fetch()

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()
    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()

    @initPieView()

  # -------------------------------------------------------------
  # Specific section initialization
  # this is functions only initialize a section of the report card
  # -------------------------------------------------------------
  @initNameAndClassification = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: GlobalVariables.CHEMBL_ID

    console.log compound

    new CompoundNameClassificationView({
        model: compound,
        el: $('#CNCCard')})
    new CompoundImageView({
        model: compound,
        el: ('#CNCImageCard')})

    compound.fetch()

    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()


  @initRepresentations = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: CHEMBL_ID

    compRepsView = new CompoundRepresentationsView
      model: compound
      el: $('#CompRepsCard')

    compound.fetch()

    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()

  @initCalculatedCompoundParentProperties = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()
    compound = new Compound
      molecule_chembl_id: CHEMBL_ID

    new CompoundCalculatedParentPropertiesView
        model: compound
        el: $('#CalculatedParentPropertiesCard')

    compound.fetch()

  @initMechanismOfAction = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + GlobalVariables.CHEMBL_ID;
    new CompoundMechanismsOfActionView
      collection: mechanismOfActionList
      el: $('#MechOfActCard')
    mechanismOfActionList.fetch({reset: true})

  @initMoleculeFeatures = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: CHEMBL_ID
    new CompoundFeaturesView
      model: compound
      el: $('#MoleculeFeaturesCard')
    compound.fetch()


  @initAlternateForms = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    compound = new Compound
      molecule_chembl_id: CHEMBL_ID

    moleculeFormsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewAlternateFormsListForCarousel()
    moleculeFormsList.initURL GlobalVariables.CHEMBL_ID

    new CompoundMoleculeFormsListView
      collection: moleculeFormsList,
      el: $('#AlternateFormsCard')

    moleculeFormsList.fetch({reset: true})

  @initSimilarCompounds = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblIDWhenEmbedded()

    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL GlobalVariables.CHEMBL_ID, glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

    new SimilarCompoundsView
      collection: similarCompoundsList
      el: $('#SimilarCompoundsCard')

    similarCompoundsList.fetch({reset: true})

  @initMetabolismFullScreen = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getUrlPartInReversePosition 0
    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL+'testData/metabolismSampleData.json'

    new CompoundMetabolismFSView
      model: compoundMetabolism
      el: $('#CompoundMetabolismMain')

    compoundMetabolism.fetch()

  @initMetabolism = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getUrlPartInReversePosition 3

    compoundMetabolism = new CompoundMetabolism()
    compoundMetabolism.url = glados.Settings.STATIC_URL+'testData/metabolismSampleData.json'

    new CompoundMetabolismView
      model: compoundMetabolism
      el: $('#MetabolismCard')

    compoundMetabolism.fetch()

  # you can provide chembld iD or a model already created
  @initMiniCompoundReportCard = ($containerElem, chemblID, model, customTemplate)->

    if model?
      compound = model
    else
      compound = new Compound({molecule_chembl_id: chemblID})

    new glados.views.MiniReportCardView
      el: $containerElem
      model: compound
      entity: Compound
      custom_template: customTemplate

    compound.fetch()

  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  @initPieView = ->
    pieview = new PieView
    pieview.render()
