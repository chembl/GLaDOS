glados.useNameSpace 'glados.models.MainPage',
  Tweet: Backbone.Model.extend {}

glados.models.MainPage.Tweet.COLUMNS =
  TWEET_ID:
    name_to_show: 'ID'
    comparator: 'id'
  HTML:
   name_to_show: 'HTML'
   comparator: 'text'
  CREATED_AT:
    name_to_show: 'CREATED AT'
    comparator: 'createdAt'
  USER_NAME:
    name_to_show: 'USERNAME'
    comparator: 'user.screenName'
  IMG_URL:
    name_to_show: 'IMG URL'
    comparator: 'user.profileImgUrl'

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
    glados.models.MainPage.Tweet.COLUMNS.CREATED_AT
    glados.models.MainPage.Tweet.COLUMNS.USER_NAME
    glados.models.MainPage.Tweet.COLUMNS.IMG_URL
  ]

glados.models.MainPage.Tweet.ID_COLUMN = glados.models.MainPage.Tweet.COLUMNS.TWEET_ID