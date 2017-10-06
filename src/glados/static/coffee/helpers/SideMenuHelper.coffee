glados.useNameSpace 'glados.helpers',

  # --------------------------------------------------------------------------------------------------------------------
  # This class provides support to functionalities related with the left navigation bar
  # --------------------------------------------------------------------------------------------------------------------
  SideMenuHelper: class SideMenuHelper

    @initializeSideMenu = ()->

      SideMenuHelper.$side_menu = $('.side-nav')
      SideMenuHelper.$chemblLogo = SideMenuHelper.$side_menu.find('.menu-logo')
      SideMenuHelper.$chemblLogoImg = SideMenuHelper.$chemblLogo.find('img')
      SideMenuHelper.initializeTopMenuController()
      SideMenuHelper.$side_menu.css
        display: 'block'
      $(".button-collapse").sideNav()
      SideMenuHelper.observeMutationsChemblHeader()

    @observeMutationsChemblHeader: ->
      updateSideNavHeader = ->
        isPinned = HeaderHelper.$chemblHeaderContainer.hasClass('pinned')
        if isPinned
          SideMenuHelper.$chemblLogo.addClass('pinned-non-materialize')
        else
          SideMenuHelper.$chemblLogo.removeClass('pinned-non-materialize')

      mutationObserver = new MutationObserver updateSideNavHeader
      mutationObserver.observe HeaderHelper.$chemblHeaderContainer[0], {
        attributes: true
        attributeFilter: ['class']
      }
      updateSideNavHeader()


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
        _.defer ->
          top = win.scrollTop()

          if top > maxPadding
            SideMenuHelper.$side_menu .css
              'paddingTop': '0px'
          else:
            SideMenuHelper.$side_menu .css
              'paddingTop': maxPadding - top + 'px'
      win.scroll scrollHandler
      scrollHandler()
