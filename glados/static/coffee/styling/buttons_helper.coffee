# ------------------------------------------------------------
# Cropped container
# ------------------------------------------------------------

expand = (elem) ->
  elem.removeClass("cropped")
  elem.addClass("expanded")

contract = (elem) ->
  elem.removeClass("expanded")
  elem.addClass("cropped")

setMoreText = (elem) ->
  icon = $(elem).children('i')
  icon.removeClass('fa-caret-up')
  icon.addClass('fa-caret-down')

setLessText = (elem) ->

  icon = $(elem).children('i')
  icon.removeClass('fa-caret-down')
  icon.addClass('fa-caret-up')



### *
  * @param {JQuery} elem element that is going to be toggled
  * @param {JQuery} buttons element that contains the buttons that activate this..
  * @return {Function} function that toggles the cropped container
###
toggleCroppedContainerWrapper = (elem, buttons) ->


  # this toggles the div elements to show or hide all the contents.
  toggleCroppedContainer = ->

    if elem.hasClass( "expanded" )
      contract(elem)
      setMoreText($(this))
      buttons.removeClass('cropped-container-btns-exp')
    else
      expand(elem)
      setLessText($(this))
      buttons.addClass('cropped-container-btns-exp')

  return toggleCroppedContainer


### *
  * Initializes the cropped container on the elements of the class 'cropped-container'
###
initCroppedContainers = ->

  $('.cropped-container').each ->

    activator = $(this).find('a[data-activates]')
    activated = $('#' + activator.attr('data-activates'))
    buttons = $(this).find('.cropped-container-btns')

    # don't bother to activate the buttons if no elements are overflowing
    overflow = false
    heightLimit = activated.offset().top + activated.height()


    activated.children().each ->

      childHeightLimit = $(this).offset().top + $(this).height()
      if childHeightLimit > heightLimit
        overflow = true
        return false

    if overflow
      toggler = toggleCroppedContainerWrapper(activated, buttons)
      activator.click(toggler)
    else
      activator.hide();


# ------------------------------------------------------------
# Expandable Menu
# ------------------------------------------------------------

showExpandableMenu = (activator, elem) ->

  activator.html('<i class="material-icons">remove</i>')
  elem.slideDown(300)

hideExpandableMenu = (activator, elem) ->

  activator.html('<i class="material-icons">add</i>')
  elem.slideUp(300)

hideExpandableMenuWrapper = (activator, elem_id_list) ->

  toggleExpandableMenu = ->

    $.each elem_id_list, (index, elem_id) ->

      elem = $('#' + elem_id)

      hideExpandableMenu(activator, elem)

  return toggleExpandableMenu

### *
* @param {JQuery} activator element that activates toggles the expandable menu
  * @param {Array} elem_id_list list of menu elements that are going to be shown
  * @return {Function} function that toggles the expandable menus
###
toggleExpandableMenuWrapper = (activator, elem_id_list) ->

  toggleExpandableMenu = ->

    $.each elem_id_list, (index, elem_id) ->

      elem = $('#' + elem_id)

      if elem.css('display') == 'none'
        showExpandableMenu(activator, elem)
      else
        hideExpandableMenu(activator, elem)

  return toggleExpandableMenu

### *
  *  Initializes the cropped container on the elements of the class 'expandable-menu'
###
initExpendableMenus = ->

  $('.expandable-menu').each ->

    currentDiv = $(this)
    activators = $(this).find('a[data-activates]')

    activators.each ->

      activator = $( this )
      activated_list = activator.attr('data-activates').split(',')

      toggler = toggleExpandableMenuWrapper(activator, activated_list)
      activator.click(toggler)

      #hide when click outside the menu
      hider = hideExpandableMenuWrapper(activator, activated_list)
      activated_list_selectors = ''
      $.each activated_list, (index, elem_id) ->
        activated_list_selectors += '#' + elem_id + ', '


      $('body').click (e) ->
        if not $.contains(currentDiv[0], e.target)
          hider()

      activator.click (event) ->
        event.stopPropagation()








