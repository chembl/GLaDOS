glados.useNameSpace 'glados.models.MainPage',
  BlogEntry: Backbone.Model.extend {}

glados.models.MainPage.BlogEntry.COLUMNS =
  TITLE:
    name_to_show: 'TITLE'
    comparator: 'title'

glados.models.MainPage.BlogEntry.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.MainPage.BlogEntry.COLUMNS
      colsList.push value
    return colsList
  )()
  INFINITE_VIEW:[
    glados.models.MainPage.BlogEntry.COLUMNS.TITLE
  ]

glados.models.MainPage.BlogEntry.ID_COLUMN = glados.models.MainPage.BlogEntry.COLUMNS.TITLE