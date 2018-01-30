# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    new glados.views.MainPage.CentralCardView
      el: $('.BCK-Central-Card')

    databaseInfo = new glados.models.MainPage.DatabaseSummaryInfo()
    console.log 'databaseInfo: ', databaseInfo
    new glados.views.MainPage.DatabaseSummaryView
      model: databaseInfo
      el: $('.BCK-Database-summary-info')

    databaseInfo.fetch()

    tweetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    tweetsList.initURL()

    console.log 'tweetsList: ', tweetsList

    tweetsList.fetch()






