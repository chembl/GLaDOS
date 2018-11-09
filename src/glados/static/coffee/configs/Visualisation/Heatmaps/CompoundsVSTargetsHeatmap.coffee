glados.useNameSpace 'glados.configs.ReportCards.Visualisation.Heatmaps',
  CompoundsVSTargetsHeatmap: class CompoundsVSTargetsHeatmap

    constructor: (@generatorList) ->

    getViewConfig: ->

      rowsEntityName = Compound.prototype.entityName
      rowsLabelProperty = 'molecule_chembl_id'
      colsEntityName = Target.prototype.entityName
      colsLabelProperty = 'target_pref_name'

      config = {
        rows_entity_name: rowsEntityName
        cols_entity_name: colsEntityName
        properties:
          molecule_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Compound',
              'CHEMBL_ID')
          target_chembl_id: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target',
              'CHEMBL_ID')
          target_pref_name: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('Target',
              'PREF_NAME')
          pchembl_value_avg: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'PCHEMBL_VALUE_AVG')
          activity_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'ACTIVITY_COUNT')
          hit_count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'HIT_COUNT')
          pchembl_value_max: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('ActivityAggregation',
              'PCHEMBL_VALUE_MAX')
        initial_colouring: 'pchembl_value_avg'
        colour_properties: ['activity_count', 'pchembl_value_avg']
        initial_row_sorting: 'activity_count'
        initial_row_sorting_reverse: true
        row_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
        initial_col_sorting: 'activity_count'
        initial_col_sorting_reverse: true
        col_sorting_properties: ['activity_count', 'pchembl_value_max', 'hit_count']
        initial_col_label_property: colsLabelProperty
        initial_row_label_property: rowsLabelProperty
        propertyToType:
          activity_count: "number"
          pchembl_value_avg: "number"
          pchembl_value_max: "number"
          hit_count: "number"
      }
      return config


    getHeatmapModelConfig: ->

      config =
        generator_list: @generatorList
        generator_axis: glados.models.Heatmap.AXES_NAMES.Y_AXIS
        generate_from_downloaded_items: true
        col_header_Link_generator: (colItem) -> Target.get_report_card_url(colItem.id)
        row_header_Link_generator: (rowItem) -> Compound.get_report_card_url(rowItem.id)
        row_footer_Link_generator: (rowItem) -> Activity.getActivitiesListURL("molecule_chembl_id:#{rowItem.id}")
        opposite_axis_generator_function: (itemsIDS) ->

          filteredTermsQueries = []

          for i in [0..glados.models.Heatmap.MAX_RELATED_IDS_LISTS]

            filteredTermsQueryI = {
              "bool": {
                "filter":{
                  "terms": {
                    "_metadata.related_compounds.chembl_ids.#{i}": itemsIDS
                  }
                }
              }
            }
            filteredTermsQueries.push(filteredTermsQueryI)

          esQuery = {
            "query": {
              "bool": {
                "should": filteredTermsQueries
              }
            }
          }

          targetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTargetsList(
            JSON.stringify(esQuery)
          )
          return targetsList

      return config



