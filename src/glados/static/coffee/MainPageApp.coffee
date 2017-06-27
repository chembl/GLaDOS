# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    @searchBarView = glados.views.SearchResults.SearchBarView.getInstance()

    new glados.views.MainPage.CentralCardView
      el: $('.BCK-Central-Card')




