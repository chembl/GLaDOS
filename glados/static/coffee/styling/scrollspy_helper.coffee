class ScrollSpyHelper

  @initializeScrollSpyPinner = ->

    # This changes the properties of the scrollspy when the page is scrolled
    # So it becomes fixed as the screen is scrolled down,
    win = $(window)
    scrollspy_wrapper = $(".scrollspy-wrapper")

    pinScrollSpy = ->

      # this is the sum of heights of the top menu bar and the banner.
      startFixation = 122
      top = win.scrollTop()

      if (top > startFixation) and (scrollspy_wrapper.css('position') != 'fixed')

        scrollspy_wrapper.removeClass('pin-top')
        scrollspy_wrapper.addClass('pinned')

      else if (top < startFixation) and (scrollspy_wrapper.css('position') != 'relative')

        scrollspy_wrapper.removeClass('pinned')
        scrollspy_wrapper.addClass('pin-top')

    win.scroll _.throttle(pinScrollSpy, 200)


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


