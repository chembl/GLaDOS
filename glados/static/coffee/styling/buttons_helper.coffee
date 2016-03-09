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
# Image with options
# ------------------------------------------------------------

### *
  * animates the top and bottom margin of the card given as a parameter to the ammounts given as a parameter
  * @param {JQuery} card element card for which the margin will changed
  * @param {Number} ammount_top by which the Top margin will be changed
  * @param {Number} ammount_bottom by which the Bottom margin  will be changed
###
animateCardMarginTopBottom = (card, ammount_top, ammount_bottom) ->

  card.animate {
    marginBottom: ammount_top
    marginTop: ammount_bottom
  }, 200


toggleCardMarginWrapper = (card, elem_id_list) ->

  # It will assume that from the element ids list,
  # the top element is always the first and the bottom element is the second
  top_base_element = $('#' + elem_id_list[0])
  bottom_base_element = $('#' + elem_id_list[1])

  toggleCardMargin = ->

    isExpanded = card.attr('data-expanded') == 'true'

    if not isExpanded
      ammount_top = '+=' + top_base_element.height()
      ammount_bottom = '+=' + bottom_base_element.height()
#      card.css
#        'margin-top': ammount_top
#        'margin-bottom': ammount_bottom
      animateCardMarginTopBottom(card, ammount_top, ammount_top)
      card.attr('data-expanded','true')
    else
      ammount_top = '-=' + top_base_element.height()
      ammount_bottom = '-=' + bottom_base_element.height()
      animateCardMarginTopBottom(card,ammount_top, ammount_bottom)
      ###card.css
        'margin-top': ammount_top
        'margin-bottom': ammount_bottom###
      card.attr('data-expanded','false')

  return toggleCardMargin


toggleExpandableMenuWrapper = (elem_id_list) ->

  toggleExpandableMenu = ->

    $.each elem_id_list, (index, elem_id) ->

      elem = $('#' + elem_id)
      if elem.css('display') == 'none'
        elem.slideDown(300)
      else
        elem.slideUp(300)

  return toggleExpandableMenu

### *
  *  Initializes the cropped container on the elements of the class 'expandable-menu'
###
initExpendableMenus = ->

  $('.expandable-menu').each ->

    current_card = $(this)

    activators = $(this).find('a[data-activates]')

    activators.each ->

      activator = $( this )
      activated_list = activator.attr('data-activates').split(',')

      menus_expander = toggleExpandableMenuWrapper(activated_list)

      if activator.attr('data-adaptMargin') == 'yes'
        margin_adapter = toggleCardMarginWrapper(current_card, activated_list)

        f = ->
          margin_adapter()
          window.setTimeout(menus_expander,250)

        activator.click(f)
      else
        activator.click(menus_expander)



