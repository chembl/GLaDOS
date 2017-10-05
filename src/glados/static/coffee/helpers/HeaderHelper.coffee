glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with the header bar
  # --------------------------------------------------------------------------------------------------------------------
  HeaderHelper: class HeaderHelper
    @initializeHeader = ()->
      HeaderHelper.$masthead = $('#masthead-contaniner')
      HeaderHelper.$chemblHeaderContainer = $('#chembl-header-container')
      HeaderHelper.$chemblHeader = HeaderHelper.$chemblHeaderContainer.find('.chembl-header')
      HeaderHelper.$chemblHeaderSidenavPushpinContainer = $('#chembl-header-sidenav-pushpin-container')
      HeaderHelper.$chemblBannerSearchBar = $('.card.search-banner')
      if HeaderHelper.$chemblBannerSearchBar.length == 1
        HeaderHelper.$chemblHeaderSidenavPushpinContainer.pushpin
          top: HeaderHelper.$masthead.height()
          offset: 0
        HeaderHelper.$chemblHeaderContainer.pushpin
          top: HeaderHelper.$chemblBannerSearchBar.offset().top + HeaderHelper.$chemblBannerSearchBar.height()-HeaderHelper.$chemblHeader.height()
          offset: 0
      else
        HeaderHelper.$chemblHeaderContainer.pushpin
          top: HeaderHelper.$masthead.height()
