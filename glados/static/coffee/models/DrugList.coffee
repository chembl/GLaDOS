DrugList = PaginatedCollection.extend

  model: Drug

  parse: (data) ->

    return data.molecules

  initialize: ->
    @meta =
      page_size: 10
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
      ]