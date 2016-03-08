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
  $(elem).text('more...')

setLessText = (elem) ->
  $(elem).text('less')



### *
  * @param {JQuery} elem element that is going to be toggled
  * @param {JQuery} buttons element that contains the buttons that activate this..
  * @return {Function} function that toggles the cropped container
###
toggleCroppedContainerWrapper = (elem, buttons) ->


  # this toggles the div elements to show or hide all the contents.
  toggleCroppedContainer = ->

    # elem and ellipsis are the variables that come from the closure

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
  * Initializes the cropped container on the current element
  * The element that calls this function must be of the class cropped-container
###
initCroppedContainers = ->

  $('.cropped-container').each ->

    activator = $(this).find('span[data-activates]')
    activated = $('#' + activator.attr('data-activates'))
    buttons = $(this).find('.cropped-container-btns')

    # don't bother to activate the buttons if there is not enough text
    numLetters = 0
    activated.children().each ->
      # the trim could be removed once the page loads from the web services
      numLetters += $(this).text().trim().length

    if numLetters < 142
      activator.hide();
      return

    toggler = toggleCroppedContainerWrapper(activated, buttons)
    activator.click(toggler)





