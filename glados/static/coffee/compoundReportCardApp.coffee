# This takes care of the handling of the report card of a compound

initCompound = (chembl_id) ->
  compound = new Compound
    molecule_chembl_id: chembl_id

  compound.url = 'https://www.ebi.ac.uk/chembl/api/data/molecule/' + chembl_id + '.json'
  return compound


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