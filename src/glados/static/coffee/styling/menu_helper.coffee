class SideMenuHelper

  @$side_menu = $('.collapsible.collapsible-accordion.side-nav')
  @additional_menus = {}
  @handlebars_template = Handlebars.compile($('#Handlebars-SideBar-CollapsibleMenu').html())

  @initializeSideMenu = ()->
    # initialization of visualization code.
    # This controls the padding of the sidenav.
    SideMenuHelper.initializeTopMenuController()
    # collapse button, the one that shows the sidenav on mobile
    $(".button-collapse").sideNav()
    SideMenuHelper.renderMenus()

  @initializeTopMenuController = ->

    # This changes the padding of the side nav when the window is scrolled.
    # So it doesn't leave a blank space when the top embl-ebi bar disapears
    win = $(window)
    $sidenav = $(".side-nav")

    maxPadding = $('#masthead-contaniner').height()
    win.resize ->
      top = win.scrollTop()
      maxPadding = $('#masthead-contaniner').height()
      $sidenav.css
        'paddingTop': maxPadding - top + 'px'
    win.scroll ->
      top = win.scrollTop()

      if top > maxPadding
        $sidenav.css
          'paddingTop': '0px'
      else:
        $sidenav.css
          'paddingTop': maxPadding - top + 'px'

  @addMenu = (menu_key, menu_data)->
    if _.isObject(menu_data)
      SideMenuHelper.additional_menus[menu_key] = menu_data
      SideMenuHelper.additional_menus[menu_key].menu_class = menu_key

  @removeMenu = (menu_key)->
    delete SideMenuHelper.additional_menus[menu_key]

  @expandMenu = (menu_key)->
    SideMenuHelper.$side_menu.find('.collapsible-header').show()
    SideMenuHelper.$side_menu.find('.collapsible-body').hide()
    SideMenuHelper.$side_menu.find('.'+menu_key).show()


  @renderMenus = (select_after_render)->
    # Shows all the headers and hides all the bodies
    SideMenuHelper.$side_menu.find('.collapsible-header').show()
    SideMenuHelper.$side_menu.find('.collapsible-body').hide()

    for menu_key_i, menu_data_i of SideMenuHelper.additional_menus
      $(SideMenuHelper.$side_menu).find('.'+menu_key_i).remove()
      html_menu = SideMenuHelper.handlebars_template(menu_data_i)
      $(SideMenuHelper.$side_menu).append(html_menu)
    # Linking selection events
    for menu_key_i, menu_data_i of SideMenuHelper.additional_menus
      for link_i in menu_data_i.links
        if link_i.select_callback and link_i.link_id
          console.log('Linking menu link', link_i.link_id, @$side_menu.find('#'+link_i.link_id).length )
          @$side_menu.find('#'+link_i.link_id).click(link_i.select_callback)

    if SideMenuHelper.$side_menu.find('.collapsible-header').length == 1
      SideMenuHelper.$side_menu.find('.collapsible-header').hide()
      SideMenuHelper.$side_menu.find('.collapsible-body').show()
    else if not _.isUndefined(select_after_render)
      SideMenuHelper.$side_menu.find('.'+select_after_render).show()