# This takes care of handling the compound report card.
class CompoundReportCardApp

  #This initializes all views and models necessary for the compound report card
  @init = ->

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
    compoundList.url = Settings.WS_BASE_URL + 'molecule_form/' + member_compound.get('molecule_chembl_id') + '.json'
    return compoundList


# -------------------------------------------------------------
# Views
# -------------------------------------------------------------

initPieView = ->
  pieview = new PieView
  pieview.render()

