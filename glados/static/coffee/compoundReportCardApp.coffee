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

initMechanismOfActionRowView = (model) ->
  mechanismOfActionRowView = new MechanismOfActionRowView
    model: model

  return mechanismOfActionRowView


### *
  * Initializes de CNCView
  * @param {Compound} model, base model for the view
  * @param {JQuery} element that renders the model.
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