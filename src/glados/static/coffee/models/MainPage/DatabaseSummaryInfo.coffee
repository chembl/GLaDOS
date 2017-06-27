glados.useNameSpace 'glados.models.MainPage',
  DatabaseSummaryInfo: Backbone.Model.extend

    initialize: ->

      config =
        db_version:
          url: glados.Settings.WS_BASE_URL + 'status.json'
          properties_to_read:
            chembl_db_version:
              prop_name: 'chembl_db_version'
              prop_label: 'chembl_db_version'
            chembl_release_date:
              prop_name: 'chembl_release_date'
              prop_label: 'chembl_release_date'
        num_targets:
          url: glados.Settings.WS_BASE_URL + 'target.json'
          properties_to_read:
            total_count:
              prop_name: 'page_meta.total_count'
              prop_label: 'num_targets'
        num_compound_records:
          url: glados.Settings.WS_BASE_URL + 'compound_record.json'
          properties_to_read:
            total_count:
              prop_name: 'page_meta.total_count'
              prop_label: 'num_compound_records'
        num_compounds:
          url: glados.Settings.WS_BASE_URL + 'molecule.json'
          properties_to_read:
            total_count:
              prop_name: 'page_meta.total_count'
              prop_label: 'num_compounds'
        num_activities:
          url: glados.Settings.WS_BASE_URL + 'activity.json'
          properties_to_read:
            total_count:
              prop_name: 'page_meta.total_count'
              prop_label: 'num_activities'
        num_publications:
          url: glados.Settings.WS_BASE_URL + 'document.json'
          properties_to_read:
            total_count:
              prop_name: 'page_meta.total_count'
              prop_label: 'num_publications'

      @set('config', config)

    fetch: ->
      config = @get('config')
      for key, item of config

        genParse = (itemName) ->
          (data) ->

            for key, property of config[itemName].properties_to_read
              propName = property.prop_name
              propLabel = property.prop_label
              propValue = glados.Utils.getNestedValue(data, propName)
              thisModel.set(propLabel, propValue)


        thisModel = @
        $.getJSON(item.url).done(genParse(key))
