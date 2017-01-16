# This takes care of handling the compound report card.
class CompoundReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

    GlobalVariables.CHEMBL_ID = URLProcessor.getRequestedChemblID()

    compound = new Compound({molecule_chembl_id: GlobalVariables.CHEMBL_ID})
    mechanismOfActionList = new MechanismOfActionList()
    mechanismOfActionList.url = glados.Settings.WS_BASE_URL + 'mechanism.json?molecule_chembl_id=' + GlobalVariables.CHEMBL_ID
    moleculeFormsList = CompoundReportCardApp.initMoleculeFormsList(compound)
    similarCompoundsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewSimilaritySearchResultsListForCarousel()
    similarCompoundsList.initURL GlobalVariables.CHEMBL_ID, glados.Settings.DEFAULT_SIMILARITY_THRESHOLD

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

    compound.fetch()
    mechanismOfActionList.fetch({reset: true})
    moleculeFormsList.fetch({reset: true})
    similarCompoundsList.fetch({reset: true})

    $('.scrollspy').scrollSpy()
    ScrollSpyHelper.initializeScrollSpyPinner()
    ButtonsHelper.initCroppedContainers()
    ButtonsHelper.initExpendableMenus()

    @initPieView()

    # remeber to make it view-specific
    $('select').material_select()

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

    moleculeFormsList = CompoundReportCardApp.initMoleculeFormsList(compound)

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

  # -------------------------------------------------------------
  # Models
  # -------------------------------------------------------------
  ### *
    * Initializes a molecule forms list given a member compound (not necessarily the parent!)
    * For now, it lazy-loads each of the compounds
    * @param {Compound} member_compound, the list of compounds
    * @return {CompoundList} the list that has been created
  ###
  @initMoleculeFormsList = (member_compound) ->
    compoundList = new CompoundList

    compoundList.original_compound = member_compound
    compoundList.origin = 'molecule_forms'
    compoundList.url = glados.Settings.WS_BASE_URL + 'molecule_form/' + member_compound.get('molecule_chembl_id') + '.json'
    return compoundList


  # -------------------------------------------------------------
  # Views
  # -------------------------------------------------------------

  @initPieView = ->
    pieview = new PieView
    pieview.render()
