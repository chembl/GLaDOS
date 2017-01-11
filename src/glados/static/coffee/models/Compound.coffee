Compound = Backbone.Model.extend(DownloadModelOrCollectionExt).extend

  initialize: ->
    @url = glados.Settings.WS_BASE_URL + 'molecule/' + @get('molecule_chembl_id') + '.json'

  parse: (response) ->

    # Calculate the rule of five from other properties
    if response.molecule_properties?
      response.ro5 = response.molecule_properties.num_ro5_violations == 0
    else
      response.ro5 = false

    return response;

Compound.COLUMNS_SETTINGS = {
  RESULTS_LIST_REPORT_CARD: [
    {
      'name_to_show': 'ChEMBL ID'
      'comparator': 'molecule_chembl_id'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
      'link_base': '/compound_report_card/$$$'
      'image_base_url': glados.Settings.WS_BASE_URL + 'image/$$$.svg?engine=indigo'
    }
    {
      'name_to_show': 'Molecule Type'
      'comparator': 'molecule_type'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Name'
      'comparator': 'pref_name'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Max Phase'
      'comparator': 'max_phase'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
    {
      'name_to_show': 'Dosed Ingredient:'
      'comparator': 'dosed_ingredient'
      'sort_disabled': false
      'is_sorting': 0
      'sort_class': 'fa-sort'
    }
  ]
}