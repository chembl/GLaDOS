glados.useNameSpace 'glados.models.paginatedCollections.SpecificFlavours',

  # This was created a long time ago, when the interface was based in the web services, it downloads and parses all the
  # items at once. We need to switch this list to use elasticsearch instead.
  # First we need to make sure that the indexs is correctly created.
  TargetRelationsList:

    initURL: (chembl_id) ->
      @url = glados.Settings.WS_BASE_URL + 'target_relation.json?related_target_chembl_id=' + chembl_id + '&order_by=target_chembl_id&limit=1000'

    fetch: ->
      this_collection = @
      target_relations = {}

      # 1 first get list of target relations
      getTargetRelations = $.getJSON(@url, (data) ->
        target_relations = data.target_relations
      )

      getTargetRelations.fail(()->
        console.log('error')
        this_collection.trigger('error')
      )

      base_url2 = glados.Settings.WS_BASE_URL + 'target.json?target_chembl_id__in='

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

# TODO:
# this is because the dev server is returning less values, this needs to be checked
            if targ.target_chembl_id != target_relations[i].target_chembl_id
              i++;

            target_relations[i].pref_name = targ.pref_name
            target_relations[i].target_type = targ.target_type

            i++

          # here everything is ready
          this_collection.setMeta('data_loaded', true)
          this_collection.reset(target_relations)
        )

        getTargetsInfo.fail(()->
          console.log('failed2')
        )
      )