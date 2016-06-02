# This initializes the entities of the compound report card

# -------------------------------------------------------------
# Models
# -------------------------------------------------------------
initCompound = (chembl_id) ->
  compound = new Compound
    molecule_chembl_id: chembl_id

  compound.url = 'https://www.ebi.ac.uk/chembl/api/data/molecule/' + chembl_id + '.json'
  return compound

### *
  * Initializes a molecule forms list given a member compound (not necessarily the parent!)
  * For now, it lazy-loads each of the compounds
  * @param {Compound} member_compound, the list of compounds
  * @return {CompoundList} the list that has been created
###
initMoleculeFormsList = (member_compound) ->
  compoundList = new CompoundList

  compoundList.original_compound = member_compound
  compoundList.origin = 'molecule_forms'
  compoundList.url = 'https://www.ebi.ac.uk/chembl/api/data/molecule_form/' + member_compound.get('molecule_chembl_id') + '.json'
  return compoundList

initMechanismOfAction = (mechanism_id) ->
  mechanismOfAction = new MechanismOfAction
    mec_id: mechanism_id

  mechanismOfAction.url = 'https://www.ebi.ac.uk/chembl/api/data/mechanism/' + mechanism_id + '.json'
  return mechanismOfAction

initMechanismOfActionList = (from_mol_chembl_id) ->
  mechanismOfActionList = new MechanismOfActionList

  mechanismOfActionList.url = 'https://www.ebi.ac.uk/chembl/api/data/mechanism.json?molecule_chembl_id=' + from_mol_chembl_id
  return mechanismOfActionList


# -------------------------------------------------------------
# Views
# -------------------------------------------------------------

### *
  * Initializes the CNCView
  * @param {Compound} model, base model for the view
  * @param {JQuery} top_level_elem element that renders the model.
  * @return {CompoundNameClassificationView} the view that has been created
###
initCNCView = (model, top_level_elem) ->
  cncView = new CompoundNameClassificationView
    model: model
    el: top_level_elem

  return cncView

### *
  * Initializes the Compound Image view, the one that is in charge of the compound main image
  * and the buttons that allow the options for it
  * @param {Compound} model, base model for the view
  * @param {JQuery} top_level_elem element that renders the model.
  * @return {CompoundNameClassificationView} the view that has been created
###
initCompoundImageView = (model, top_level_elem) ->

  compImgView = new CompoundImageView
    model: model
    el: top_level_elem

  return compImgView

### *
  * Initializes de Compound Representations View
  * @param {Compound} model, base model for the view
  * @param {JQuery} element that renders the model.
  * @return {CompoundNameClassificationView} the view that has been created
###
initCompRepsView = (model, top_level_elem) ->
  compRepsView = new CompoundRepresentationsView
    model: model
    el: top_level_elem

  return compRepsView

initCalcCompPropertiesView = (model, top_level_elem) ->
  calcCompPropView = new CompoundCalculatedParentPropertiesView
    model: model
    el: top_level_elem

  return calcCompPropView

### *
  * Initializes de MechanismOfActionRowView View, This view renders a row of a table
  * from the information on the mechanism of action.
  * @param {Compound} model, base model for the view
  * @return {MechanismOfActionRowView} the view that has been created
###
initMechanismOfActionRowView = (model) ->
  mechanismOfActionRowView = new MechanismOfActionRowView
    model: model

  return mechanismOfActionRowView

### *
  * Initializes de MechanismOfActionRowTable View, This view knows all the mechanisms of action from a compound
  * @param {MechanismOfActionList} mech_of_act_list, list of mechanisms of action
  * @param {JQuery} top_level_elem element that renders the model.
  * @return {MechanismOfActionTableView} the view that has been created
###
initCompMechanismsOfActionView = (mech_of_action_list, top_level_elem) ->
  compoundMechanismsOfActionView = new CompoundMechanismsOfActionView
    collection: mech_of_action_list
    el: top_level_elem

  return compoundMechanismsOfActionView

### *
  * Initializes de Compound Featues View
  * @param {Compound} model, base model for the view
  * @param {JQuery} element that renders the model.
  * @return {CompoundNameClassificationView} the view that has been created
###
initCompFeaturesView = (model, top_level_elem) ->
  compFeaturesView = new CompoundFeaturesView
    model: model
    el: top_level_elem

  return compFeaturesView

### *
  * Initializes de CompoundMoleculeFormsListView, This view knows all the alternate forms of a compound
  * @param {CompoundList} compound_list, list of compounds
  * @param {JQuery} top_level_elem element for this view.
  * @return {CompoundMoleculeFormsListView} the view that has been created
###
initCompMoleculeFormsListView = (compound_list, top_level_elem) ->
  compoundMoleculeFormsListView = new CompoundMoleculeFormsListView
    collection: compound_list
    el: top_level_elem

  return compoundMoleculeFormsListView

initPieView = ->
  pieview = new PieView
  console.log(pieview)
  pieview.render()

### *
  * Initializes an iframe lazy loader. This view knows hot to lazy load an iframe
  * @param {Compound} model, base model for the view
  * @param {JQuery} element that renders the model.
  * @return {CompoundNameClassificationView} the view that has been created
###
initIFrameLazyLoader = (model, top_level_elem) ->
  iFrameLazyLoader = new IFrameLazyLoader
    model: model
    el: top_level_elem

  return iFrameLazyLoader

