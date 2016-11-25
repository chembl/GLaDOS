class SideMenuHelper

  @initializeTopMenuController = ->

    # This changes the padding of the side nav when the window is scrolled.
    # So it doesn't leave a blank space when the top embl-ebi bar disapears
    win = $(window)
    sidenav_fixed = $(".side-nav.fixed")

    win.scroll ->
      maxPadding = 32
      top = win.scrollTop()

      if top > maxPadding
        sidenav_fixed.css
          'paddingTop': '0px'
      else:
        sidenav_fixed.css
          'paddingTop': maxPadding - top + 'px'

  # ------------------------------------------------------------
  # sidenav
  # ------------------------------------------------------------

  ### *
    *  This is necessary to fix the bug of the side nav not appearing correctly.
  ###
  @complementaryinitSideNav = ->

    $('.button-collapse').each ->

      currentBtn = $(this)
      currentBtn.click ->

        activated = $('#' + $(@).attr('data-activates'))
        activated.show()