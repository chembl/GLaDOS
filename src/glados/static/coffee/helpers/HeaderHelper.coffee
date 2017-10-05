glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with the header bar
  # --------------------------------------------------------------------------------------------------------------------
  HeaderHelper: class HeaderHelper
    @initializeHeader = ()->
      $masthead = $('#masthead-contaniner')
      $chemblHeaderContainer = $('#chembl-header-container')
      $chemblHeader = $chemblHeaderContainer.find('.chembl-header')
      $chemblHeaderSidenavPushpinContainer = $('#chembl-header-sidenav-pushpin-container')

      $chemblBannerSearchBar = $('.card.search-banner')
      if $chemblBannerSearchBar.length == 1
        $chemblHeaderSidenavPushpinContainer.pushpin
          top: $masthead.height()
          offset: 0
        $chemblHeaderContainer.pushpin
          top: $chemblBannerSearchBar.offset().top + $chemblBannerSearchBar.height()-$chemblHeader.height()
          offset: 0
      else
        $chemblHeaderContainer.pushpin
          top: $masthead.height()
