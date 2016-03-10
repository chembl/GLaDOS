# This takes care of the handling of the report card of a compound

compound = new Compound(molecule_chembl_id: 'CHEMBL25')

### *
  * Initializes de CNCView
  * @param {Compound} model, base model for the view
  * @param {JQuery} element that renders the model.
  * @return {CompoundNameClassificationView} the view that has been created
###
initCNCView = (model, top_level_elem) ->

  cncView = new CompoundNameClassificationView
    model: compound
    el: top_level_elem

  return cncView

