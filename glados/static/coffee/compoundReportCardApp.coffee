# This takes care of the handling of the report card of a compound

initCompound = (chembl_id) ->
  compound = new Compound
    molecule_chembl_id: chembl_id

  compound.url = 'https://www.ebi.ac.uk/chembl/api/data/molecule/' + chembl_id + '.json'
  return compound

initMechanismOfAction = (mechanism_id) ->
  mechanismOfAction = new MechanismOfAction
    mec_id: mechanism_id

  mechanismOfAction.url = 'https://www.ebi.ac.uk/chembl/api/data/mechanism/' + mechanism_id + '.json'
  return mechanismOfAction

initMechanismOfActionList = (from_mol_chembl_id) ->
  mechanismOfActionList = new MechanismOfActionList

  mechanismOfActionList.url = 'https://www.ebi.ac.uk/chembl/api/data/mechanism.json?molecule_chembl_id=' + from_mol_chembl_id

  return mechanismOfActionList


### *
  * Initializes de CNCView
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