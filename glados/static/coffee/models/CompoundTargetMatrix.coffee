CompoundTargetMatrix = Backbone.Model.extend

  initialize: ->
    @url = 'https://www.ebi.ac.uk/chembl/api/data/activity.json?limit=1000&molecule_chembl_id__in=CHEMBL554,CHEMBL212250,CHEMBL212201,CHEMBL212251,CHEMBL384407,CHEMBL387207,CHEMBL215814,CHEMBL383965,CHEMBL214487,CHEMBL212954,CHEMBL213342,CHEMBL215716,CHEMBL213818,CHEMBL212965,CHEMBL214023,CHEMBL265367,CHEMBL215171,CHEMBL214419,CHEMBL384711,CHEMBL380247,CHEMBL215993,CHEMBL377437,CHEMBL214689,CHEMBL213822,CHEMBL215033,CHEMBL445572,CHEMBL377250,CHEMBL490062,CHEMBL588324,CHEMBL528983,CHEMBL529972,CHEMBL528234,CHEMBL532686,CHEMBL546497,CHEMBL548563,CHEMBL1630107,CHEMBL1630111,CHEMBL1630113,CHEMBL1630117,CHEMBL1794063,CHEMBL2347565,CHEMBL2347566,CHEMBL2347567,CHEMBL2407820,CHEMBL3040455,CHEMBL3040543,CHEMBL3040548,CHEMBL3040566,CHEMBL3040597,CHEMBL3344208,CHEMBL3344209,CHEMBL3344210,CHEMBL3344211,CHEMBL3344212,CHEMBL3344213,CHEMBL3344214,CHEMBL3344215,CHEMBL3344216,CHEMBL3344217,CHEMBL3344218,CHEMBL3344219,CHEMBL3344220,CHEMBL3344221,CHEMBL3526263,CHEMBL3526326,CHEMBL3526479,CHEMBL3526480,CHEMBL3526609,CHEMBL3526763,CHEMBL3526764,CHEMBL3526765,CHEMBL3527094,CHEMBL3527095,CHEMBL3542267,CHEMBL3542268,CHEMBL3546948,CHEMBL3546949,CHEMBL3546966,CHEMBL3546967,CHEMBL3546968,CHEMBL3546969,CHEMBL3546976,CHEMBL3666714,CHEMBL3706535'
#    @url = 'https://www.ebi.ac.uk/chembl/api/data/activity.json&molecule_chembl_id__in=CHEMBL554,CHEMBL212250,CHEMBL212201,CHEMBL212251,CHEMBL384407,CHEMBL387207,CHEMBL215814,CHEMBL383965,CHEMBL214487,CHEMBL212954,CHEMBL213342,CHEMBL215716,CHEMBL213818,CHEMBL212965,CHEMBL214023,CHEMBL265367,CHEMBL215171,CHEMBL214419,CHEMBL384711,CHEMBL380247,CHEMBL215993,CHEMBL377437,CHEMBL214689,CHEMBL213822,CHEMBL215033,CHEMBL445572,CHEMBL377250,CHEMBL490062,CHEMBL588324,CHEMBL528983,CHEMBL529972,CHEMBL528234,CHEMBL532686,CHEMBL546497,CHEMBL548563,CHEMBL1630111,CHEMBL1630113,CHEMBL1630117,CHEMBL1794063,CHEMBL2347565,CHEMBL2347566,CHEMBL2347567,CHEMBL2407820,CHEMBL3040455,CHEMBL3040543,CHEMBL3040548,CHEMBL3040566,CHEMBL3040597,CHEMBL3344208,CHEMBL3344209,CHEMBL3344210,CHEMBL3344211,CHEMBL3344212,CHEMBL3344213,CHEMBL3344214,CHEMBL3344215,CHEMBL3344216,CHEMBL3344217,CHEMBL3344218,CHEMBL3344219,CHEMBL3344220,CHEMBL3344221,CHEMBL3526263,CHEMBL3526326,CHEMBL3526479,CHEMBL3526480,CHEMBL3526609,CHEMBL3526763,CHEMBL3526764,CHEMBL3526765,CHEMBL3527094,CHEMBL3527095,CHEMBL3542267,CHEMBL3542268,CHEMBL3546948,CHEMBL3546949,CHEMBL3546966,CHEMBL3546967,CHEMBL3546968,CHEMBL3546969,CHEMBL3546976,CHEMBL3666714,CHEMBL3706535'

    console.log @url

    config = {
      initial_colouring: 'assay_type'
      colour_properties: ['pchembl_value', 'assay_type', 'published_value']
      initial_row_sorting: 'pchembl_value'
      row_sorting_properties: ['pchembl_value', 'published_value']
      initial_col_sorting: 'published_value'
      col_sorting_properties: ['pchembl_value', 'published_value']
      propertyToType:
        assay_type: "string"
        pchembl_value: "number"
        published_value: "number"
    }

    @set('config', config)

  parse: (response) ->

    activities = response.activities

    console.log 'TEST: ', _.pluck(activities, 'molecule_chembl_id')

    compoundsToPosition = {}
    targetsToPosition = {}
    links = {}

    compoundsList = []
    latestCompPos = 0
    targetsList = []
    latestTargPos = 0

    for act in activities
      currentCompound = act.molecule_chembl_id
      currentTarget = act.target_chembl_id

      if not compoundsToPosition[currentCompound]?
        compoundsList.push {"name": currentCompound}
        compoundsToPosition[currentCompound] = latestCompPos
        latestCompPos++

      if not targetsToPosition[currentTarget]?
        targetsList.push {"name": currentTarget}
        targetsToPosition[currentTarget] = latestTargPos
        latestTargPos++

      compPos = compoundsToPosition[currentCompound]
      targPos = targetsToPosition[currentTarget]

      if not links[targPos]?
        links[targPos] = {}

      links[targPos][compPos] = act

    # fill missing values with {}
    for i in [0..(targetsList.length - 1)]
      row = links[i]
      if not row?
        links[i] = {}

      for j in [0..(compoundsList.length - 1)]
        cell = links[i][j]
        if not cell?
          links[i][j] = {
            molecule_chembl_id: links[targPos][compPos]['molecule_chembl_id']
            target_chembl_id: links[targPos][compPos]['target_chembl_id']
          }

    result =
      "columns": compoundsList
      "rows": targetsList
      "links": links

    console.log 'result: ', result

    return {"matrix": result}