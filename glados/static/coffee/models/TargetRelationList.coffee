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
          {
            'name_to_show': 'Pref Name'
            'comparator': 'pref_name'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
          {
            'name_to_show': 'Target Type'
            'comparator': 'target_type'
            'sort_disabled': false
            'is_sorting': 0
            'sort_class': 'fa-sort'
          }
        ]


    @on 'reset', @resetMeta, @

  fetch: ->

    this_collection = @
    target_relations = {}

    # 1 first get list of target relations
    getTargetRelations = $.getJSON(@url, (data) ->
      target_relations = data.target_relations
    )

    getTargetRelations.fail( ()->

      console.log('error')
      this_collection.trigger('error')

    )

    base_url2 = 'https://wwwdev.ebi.ac.uk/chembl/api/data/target.json?target_chembl_id__in='

    # after I have the target relations now I get the actual targets
    getTargetRelations.done(() ->

      targets_list = (t.target_chembl_id for t in target_relations).join(',')
      # order is very important to iterate in the same order as the first call
      getTargetssInfoUrl = base_url2 + targets_list + '&order_by=target_chembl_id&limit=1000'

      getTargetsInfo = $.getJSON(getTargetssInfoUrl, (data) ->

        targets = data.targets
        # Now I fill the missing information, both arrays are ordered by target_chembl_id
        i = 0
        for targ in targets

          # ATENTION:
          # this is because the dev server is returning less values, this needs to be checked
          if targ.target_chembl_id != target_relations[i].target_chembl_id
            i++;

          target_relations[i].pref_name = targ.pref_name
          target_relations[i].target_type = targ.target_type

          i++

        # here everything is ready
        this_collection.reset(target_relations)
        data = _.map(target_relations, (o)-> [o.target_chembl_id, o.pref_name])
        console.log(JSON.stringify(data))

      )

      getTargetsInfo.fail( ()->

        console.log('failed2')

      )


    )