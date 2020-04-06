TargetComponent = Backbone.Model.extend

  parse: (data) ->
    parsed = data
    parsed.accession_url = ''
    if _.has(parsed, 'accession')
        parsed.accession_url =  "https://www.uniprot.org/uniprot/#{parsed.accession}"
    return parsed;

TargetComponent.COLUMNS = {
  DESCRIPTION:{
    'name_to_show': 'Description'
    'comparator': 'component_description'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  RELATIONSHIP:{
    'name_to_show': 'Relationship'
    'comparator': 'relationship'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
  }
  ACCESSION:{
    'name_to_show': 'Accession'
    'comparator': 'accession'
    'sort_disabled': false
    'is_sorting': 0
    'sort_class': 'fa-sort'
    'link_base': 'accession_url'
  }
}

TargetComponent.ID_COLUMN = TargetComponent.COLUMNS.DESCRIPTION

TargetComponent.COLUMNS_SETTINGS = {
  ALL_COLUMNS: (->
    colsList = []
    for key, value of TargetComponent.COLUMNS
      colsList.push value
    return colsList
  )()
  RESULTS_LIST_TABLE: [
    TargetComponent.COLUMNS.DESCRIPTION
    TargetComponent.COLUMNS.RELATIONSHIP
    TargetComponent.COLUMNS.ACCESSION
  ]
}
