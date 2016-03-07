# ------------------------------------------------------------
# Cropped container
# ------------------------------------------------------------

expand = (elem) ->
  elem.removeClass("cropped")
  elem.addClass("expanded")

contract = (elem) ->
  elem.removeClass("expanded")
  elem.addClass("cropped")

setExpandIcon = (elem) ->
  $(elem).removeClass('fa-compress')
  $(elem).addClass('fa-expand')

setContractIcon = (elem) ->
  $(elem).addClass('fa-compress')
  $(elem).removeClass('fa-expand')

setExpandTooltip = (elem) ->
  $(elem).attr('data-tooltip','Expand')

setContractTooltip = (elem) ->
  $(elem).attr('data-tooltip','Contract')


### *
  * @param {JQuery} elem element that is going to be toggled
  * @param {JQuery} ellipsis element that contains the ellipsis to be hidden.
  * @return {Function} function that toggles the cropped container
###
toggleCroppedContainerWrapper = (elem, ellipsis) ->


  # this toggles the div elements to show or hide all the contents.
  toggleCroppedContainer = ->

    # elem and ellipsis are the variables that come from the closure

    if elem.hasClass( "expanded" )
      contract(elem)
      ellipsis.show()
      setExpandIcon($(this).find('i'))
      setExpandTooltip($(this))

    else
      expand(elem)
      ellipsis.hide()
      setContractIcon($(this).find('i'))
      setContractTooltip($(this))

  return toggleCroppedContainer


### *
  * Initializes the cropped container on the current element
  * The element that calls this function must be of the class cropped-container
###
initCroppedContainers = ->

  $('.cropped-container').each ->

    activator = $(this).find('a[data-activates]')
    activated = $('#' + activator.attr('data-activates'))
    ellipsis = $(this).find('.cropped-container-ellipsis')

    # don't bother to activate the buttons if there is not enough text
    numLetters = 0
    activated.children().each ->
      # the trim could be removed once the page loads from the web services
      numLetters += $(this).text().trim().length

    if numLetters < 142
      ellipsis.hide()
      activator.hide();
      return


    console.log(activated.children().text().length)

    toggler = toggleCroppedContainerWrapper(activated, ellipsis)
    activator.click(toggler)





