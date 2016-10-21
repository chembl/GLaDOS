CompoundTargetMatrix = Backbone.Model.extend

  initialize: ->
    @url = 'https://www.ebi.ac.uk/chembl/api/data/activity.json?limit=40&pchembl_value__isnull=false'

  parse: (response) ->

    activities = response.activities

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
          links[i][j] = {}

    result =
      "columns": compoundsList
      "rows": targetsList
      "links": links

    console.log 'result: ', result

    return {"matrix": result}