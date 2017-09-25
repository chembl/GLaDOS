glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with the header bar
  # --------------------------------------------------------------------------------------------------------------------
  HeaderHelper: class HeaderHelper
    @initializeHeader = ()->
      $masthead = $('#masthead-contaniner')
      $chemblHeader = $('#chembl-header-container')
      $chemblHeader.pushpin
        top: $masthead.height()
