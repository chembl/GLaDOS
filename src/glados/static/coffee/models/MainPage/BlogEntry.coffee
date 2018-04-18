glados.useNameSpace 'glados.models.MainPage',
  BlogEntry: Backbone.Model.extend {}

glados.models.MainPage.BlogEntry.COLUMNS =
  TITLE:
    name_to_show: 'TITLE'
    comparator: 'title'
  URL:
    name_to_show: 'URL'
    comparator: 'url'
  AUTHOR:
    name_to_show: 'AUTHOR'
    comparator: 'author'
  AUTHOR_URL:
    name_to_show: 'AUTHOR URL'
    comparator: 'author_url'
  DATE:
    name_to_show: 'DATE'
    comparator: 'date'


glados.models.MainPage.BlogEntry.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.MainPage.BlogEntry.COLUMNS
      colsList.push value
    return colsList
  )()
  INFINITE_VIEW:[
    glados.models.MainPage.BlogEntry.COLUMNS.TITLE
    glados.models.MainPage.BlogEntry.COLUMNS.URL
    glados.models.MainPage.BlogEntry.COLUMNS.AUTHOR
    glados.models.MainPage.BlogEntry.COLUMNS.AUTHOR_URL
    glados.models.MainPage.BlogEntry.COLUMNS.DATE
  ]

glados.models.MainPage.BlogEntry.ID_COLUMN = glados.models.MainPage.BlogEntry.COLUMNS.TITLE