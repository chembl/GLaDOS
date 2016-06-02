class DownloadMenuHelper

  #The structure for the menu must be like this:
  #  everything must me in a div of class js-db-menu-container
  #
  # Any div that is of the class js-db-menu-item is a item to be shown in the menu
  # <div id="downloads" class="js-db-menu-item">
  #  <h1> SQL Downloads </h1>
  #  ...
  # </div>
  #
  # Any link of the class js-db-menu-link is a link to a menu item
  # <a class="js-db-menu-link" href="#downloads">...</a>
  # the href attribute will be used to know to which item it is linked
  @initDownloadMenuHelper = ->

    $('.js-db-menu-container').each ->

      currentMenu = $(this)

      currentMenu.find('.active').show()

      currentMenu.find('.js-db-menu-link').each ->