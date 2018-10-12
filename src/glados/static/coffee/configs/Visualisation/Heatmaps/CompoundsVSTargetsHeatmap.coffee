glados.useNameSpace 'glados.configs.ReportCards.Visualisation.Heatmaps',
  CompoundsVSTargetsHeatmap: class CompoundsVSTargetsHeatmap

    constructor: (@generatorList) ->

    getHeatmapModelConfig: ->

      config =
        generator_list: @generatorList
        generator_axis: glados.models.Heatmap.AXES_NAMES.Y_AXIS
        generate_from_downloaded_items: true
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



