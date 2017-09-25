glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with the left navigation bar
  # --------------------------------------------------------------------------------------------------------------------
  SideMenuHelper: class SideMenuHelper

    @initializeSideMenu = ()->

      SideMenuHelper.$side_menu = $('.side-nav')
      SideMenuHelper.initializeTopMenuController()
      $(".button-collapse").sideNav()
      
    @initializeTopMenuController = ->

      # This changes the padding of the side nav when the window is scrolled.
      # So it doesn't leave a blank space when the top embl-ebi bar disapears
      win = $(window)

      maxPadding = $('#masthead-contaniner').height()
      win.resize ->
        top = win.scrollTop()
        maxPadding = $('#masthead-contaniner').height()
        footer_h = $('footer').height()
        SideMenuHelper.$side_menu .css
          'paddingBottom': footer_h + 'px'
          'paddingTop': maxPadding - top + 'px'

      scrollHandler = ->
        top = win.scrollTop()

        if top > maxPadding
          SideMenuHelper.$side_menu .css
            'paddingTop': '0px'
        else:
          SideMenuHelper.$side_menu .css
            'paddingTop': maxPadding - top + 'px'
      win.scroll scrollHandler
      scrollHandler()
