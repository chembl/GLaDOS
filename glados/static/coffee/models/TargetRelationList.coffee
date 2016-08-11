TargetRelationList = PaginatedCollection.extend

  model: TargetRelation

  parse: (data) ->

    return data.target_relations

  initialize: ->
    @meta =
      page_size: 10
      current_page: 1
      to_show: []
      columns: [
          {
            'name_to_show': 'ChEMBL ID'
            'comparator': 'target_chembl_id'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
            'link_base': '/target_report_card/$$$'
          }
          {
            'name_to_show': 'Relationship'
            'comparator': 'relationship'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
        ]


    @on 'reset', @resetMeta, @