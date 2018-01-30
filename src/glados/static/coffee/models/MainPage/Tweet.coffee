glados.useNameSpace 'glados.models.MainPage',
  Tweet: Backbone.Model.extend {}

glados.models.MainPage.Tweet.COLUMNS =
  TWEET_ID:
    name_to_show: 'id'
    comparator: 'id'
  HTML:
   name_to_show: 'html'
   comparator: 'text'

glados.models.MainPage.Tweet.COLUMNS_SETTINGS =
  ALL_COLUMNS: (->
    colsList = []
    for key, value of glados.models.MainPage.Tweet.COLUMNS
      colsList.push value
    return colsList
  )()
  INFINITE_VIEW:[
    glados.models.MainPage.Tweet.COLUMNS.TWEET_ID
    glados.models.MainPage.Tweet.COLUMNS.HTML

  ]

glados.models.MainPage.Tweet.ID_COLUMN = glados.models.MainPage.Tweet.COLUMNS.TWEET_ID