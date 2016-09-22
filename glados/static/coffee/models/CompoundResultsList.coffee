CompoundResultsList = PaginatedCollection.extend

  model: Compound

  parse: (data) ->

    data.page_meta.records_in_page = data.molecules.length
    @resetMeta(data.page_meta)

    return data.molecules

  initialize: ->

    @meta =
      server_side: true
      base_url: Settings.WS_BASE_URL + 'molecule.json'
      page_size: 6
      current_page: 1
      to_show: []
      columns: [
        {
          'name_to_show': 'ChEMBL ID'
          'comparator': 'molecule_chembl_id'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
          'link_base': '/compound_report_card/$$$'
          'image_base_url': Settings.WS_BASE_URL + 'image/$$$.svg'
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

    @url = @getMeta('base_url')