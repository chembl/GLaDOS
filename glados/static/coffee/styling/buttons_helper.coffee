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

    console.log(overflow)
    if overflow
      toggler = toggleCroppedContainerWrapper(activated, buttons)
      activator.click(toggler)
    else
      activator.hide();


# ------------------------------------------------------------
# Image with options
# ------------------------------------------------------------

toggleExpandableMenuWrapper = (elem) ->

  toggleExpandableMenu = ->

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

    activator = $(this).find('a[data-activates]')
    activated = $('#' + activator.attr('data-activates'))

    toggler = toggleExpandableMenuWrapper(activated)
    activator.click(toggler)



