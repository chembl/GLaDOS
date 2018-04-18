class ButtonsHelper

  # ------------------------------------------------------------
  # Modals
  # ------------------------------------------------------------
  # it returns the element that has the modal contents so it can be used to bind views to it.
  @generateModalFromTemplate = ($trigger, templateID, startingTop=undefined , endingTop=undefined, customID, templateParams) ->

    if $trigger?
      if $trigger.attr('data-modal-configured') == 'yes'
        return

    if $('#'+templateID).attr('data-starting-top')
      startingTop = $('#'+templateID).attr('data-starting-top')
    if $('#'+templateID).attr('data-ending-top')
      endingTop = $('#'+templateID).attr('data-ending-top')
    options = {}
    if startingTop?
      options.startingTop = startingTop
    if endingTop?
      options.endingTop = endingTop
    else if startingTop?
      options.endingTop = startingTop

    modalId = customID
    modalId ?= 'modal-' + (new Date()).getTime()
    templateParams = _.extend({id: modalId}, templateParams)
    console.log 'templateParams: ', templateParams
    $('#BCK-GeneratedModalsContainer').append($(glados.Utils.getContentFromTemplate(templateID, templateParams)))
    $newModal = $('#' + modalId)
    $newModal.modal options


    if $trigger?
      $trigger.attr('href', '#' + modalId).addClass('modal-trigger')
      $trigger.attr('data-modal-configured', 'yes')

    return $newModal

  # ------------------------------------------------------------
  # Cropped Container
  # ------------------------------------------------------------
  @initCroppedContainer: ($containerElem, config) ->

    downloadBtnID = "DownloadBtn-#{(new Date()).getTime()}"
    copyButtonID = "CopyBtn-#{(new Date()).getTime()}"
    value = config.value
    downloadFilename = config.download.filename
    downloadValue = config.download.value
    downloadValue ?= value
    downloadTooltip = config.download.tooltip
    downloadTooltip ?= 'Download'
    copyTooltip = 'Copy to Clipboard'

    glados.Utils.fillContentForElement $containerElem,
      dwnld_btn_id: downloadBtnID
      copy_btn_id: copyButtonID
      value: value

    ButtonsHelper.initCroppedTextFields($containerElem)
    ButtonsHelper.initDownloadBtn($containerElem.find("##{downloadBtnID}"), downloadFilename, downloadTooltip, downloadValue)
    $copyBtn = $containerElem.find("##{copyButtonID}")
    ButtonsHelper.initCopyButton($copyBtn, copyTooltip, value)

  # ------------------------------------------------------------
  # Download buttons
  # ------------------------------------------------------------

  ### *
    * @param {JQuery} elem button that triggers the download
    * @param {String} Tooltip that you want for the button
    * @param {function} function to be called on click
  ###
  @initLinkButton = (elem, tooltip, click_cb) ->
    elem.addClass('tooltipped')
    elem.attr('data-tooltip', tooltip)
    if click_cb?
      elem.click( click_cb )


  ### *
    * @param {JQuery} elem button that triggers the download
    * @param {String} filename Name that you want for the downloaded file
    * @param {String} Tooltip that you want for the button
    * @param {String} data data that is going to be downloaded
  ###
  @initDownloadBtn = ($btn, filename, tooltip, data)->
    $btn.attr('download', filename,)
    $btn.addClass('tooltipped')
    $btn.attr('data-tooltip', tooltip)
    $btn.attr('href', 'data:text/html,' + data)
    $btn.tooltip()

  ### *
    * Handles the copy event receiving the data to be copied as a parameter
    * it gets the information from the context, It doesn't use a closure to be faster
  ###
  @handleCopyDynamic = (elem, data)->
    clipboard.copy(data)
    if elem
      tooltip_id = elem.attr('data-tooltip-id')
      if tooltip_id
        tooltip = $('#' + tooltip_id)
        if $( window ).width() <= glados.SMALL_SCREEN_SIZE
          tooltip.hide()
          Materialize.toast('Copied!', 1000)
        else
          prev_text = tooltip.find('span').text()
          tooltip.find('span').text('Copied!')
          reset_text = ->
            tooltip.find('span').text(prev_text)
          setTimeout(reset_text, 1000)

  ### *
    * Handles the copy event
    * it gets the information from the context, It doesn't use a closure to be faster
  ###
  @handleCopy = ->

    clipboard.copy($(@).attr('data-copy'))
    tooltip_id = $(@).attr('data-tooltip-id')
    tooltip = $('#' + tooltip_id)

    if $( window ).width() <= glados.SMALL_SCREEN_SIZE
      tooltip.hide()
      Materialize.toast('Copied!', 1000)
    else
      prev_text = tooltip.find('span').text()
      tooltip.find('span').text('Copied!')
      reset_text = ->
        tooltip.find('span').text(prev_text)
      setTimeout(reset_text, 1000)


  @initCopyButton = (elem, tooltip, data) ->

    $copyBtn = elem
    $copyBtn.addClass('tooltipped')
    $copyBtn.attr('data-tooltip', tooltip)
    $copyBtn.attr('data-copy', data )
    $copyBtn.click ButtonsHelper.handleCopy
    $copyBtn.tooltip()

  # ------------------------------------------------------------
  # Cropped container
  # ------------------------------------------------------------

  @expand = (elem) ->
    elem.removeClass("cropped")
    elem.addClass("expanded")

  @contract = (elem) ->
    elem.removeClass("expanded")
    elem.addClass("cropped")

  @setMoreText = (elem) ->

    $(elem).text('more...')

  @setLessText = (elem) ->

    $(elem).text('less...')

  ### *
    * @param {JQuery} elem element that is going to be toggled
    * @param {JQuery} buttons element that contains the buttons that activate this..
    * @return {Function} function that toggles the cropped container
  ###
  @toggleCroppedContainerWrapper = (elem, buttons) ->


    # this toggles the div elements to show or hide all the contents.
    toggleCroppedContainer = ->

      if elem.hasClass( "expanded" )
        ButtonsHelper.contract(elem)
        ButtonsHelper.setMoreText($(this))
        buttons.removeClass('cropped-container-btns-exp')
      else
        ButtonsHelper.expand(elem)
        ButtonsHelper.setLessText($(this))
        buttons.addClass('cropped-container-btns-exp')

    return toggleCroppedContainer


  ### *
    * Initializes the cropped container on the elements of the class 'cropped-container'
  ###
  @initCroppedContainers = ->

    f = _.debounce( ->

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

          if !activator.hasClass('toggler-bound')
            toggler = ButtonsHelper.toggleCroppedContainerWrapper(activated, buttons)
            activator.addClass('toggler-bound')
            activator.click(toggler)

          activator.show()
        else
          activator.hide()
    , 300)

    $(window).resize f

    f()



  # ------------------------------------------------------------
  # Expandable Menu
  # ------------------------------------------------------------

  @showExpandableMenu = (activator, elem) ->
    activator.html('<i class="material-icons">remove</i>')
    elem.slideDown(300)

  @hideExpandableMenu = (activator, elem) ->
    activator.html('<i class="material-icons">add</i>')
    elem.slideUp(300)

  @hideExpandableMenuWrapper = (activator, elem_id_list) ->

    toggleExpandableMenu = ->

      $.each elem_id_list, (index, elem_id) ->

        elem = $('#' + elem_id)

        ButtonsHelper.hideExpandableMenu(activator, elem)

    return toggleExpandableMenu

  ### *
  * @param {JQuery} activator element that activates toggles the expandable menu
    * @param {Array} elem_id_list list of menu elements that are going to be shown
    * @return {Function} function that toggles the expandable menus
  ###
  @toggleExpandableMenuWrapper = (activator, elem_id_list) ->

    toggleExpandableMenu = ->

      $.each elem_id_list, (index, elem_id) ->

        elem = $('#' + elem_id)

        if not elem.is(':visible')
          ButtonsHelper.showExpandableMenu(activator, elem)
        else
          ButtonsHelper.hideExpandableMenu(activator, elem)

    return toggleExpandableMenu

  ### *
    *  Initializes the toggler on the elements of the class 'expandable-menu'
  ###
  @initExpendableMenus = ->

    $('.expandable-menu').each ->

      currentDiv = $(this)
      activators = $(this).find('a[data-activates]')

      activators.each ->

        activator = $( this )
        activated_list = activator.attr('data-activates').split(',')

        toggler = ButtonsHelper.toggleExpandableMenuWrapper(activator, activated_list)
        activator.click(toggler)

        #hide when click outside the menu
        hider = ButtonsHelper.hideExpandableMenuWrapper(activator, activated_list)
        activated_list_selectors = ''
        $.each activated_list, (index, elem_id) ->
          activated_list_selectors += '#' + elem_id + ', '


        $('body').click (e) ->
          if not $.contains(currentDiv[0], e.target)
            hider()

        activator.click (event) ->
          event.stopPropagation()


  # ------------------------------------------------------------
  # cropped text field
  # ------------------------------------------------------------


  ### *
    *  Initializes the cropped container on the elements of the class 'cropped-text-field'
    * It is based on an input field to show the information
  ###
  @initCroppedTextFields = ($container) ->

    $container.find('.cropped-text-field').each ->

      currentDiv = $(this)
      input_field = $(this).find('input')
      input_field.click ->
        input_field.val(currentDiv.attr('data-original-value'))
        input_field.select()

      # this is to allow to easily modify the content of the input if it needs to be cropped
      $(this).attr('data-original-value', input_field.attr('value'))

      input_field.focusout ->
        ButtonsHelper.cropTextIfNecessary(currentDiv)

      $( window ).resize ->

        if currentDiv.is(':visible')
          ButtonsHelper.cropTextIfNecessary(currentDiv)


      ButtonsHelper.cropTextIfNecessary(currentDiv)

  ### *
    * Decides if the input contained in the div is overlapping and the ellipsis must be shown.
    * if it is overlapping, shows the ellipsis and crops the text, if not, it doesn't show the ellipsis
    * and shows all the text in the input
    * @param {JQuery} input_div element that contains the ellipsis and the input
  ###
  @cropTextIfNecessary = (input_div)->

    input_field = input_div.find('input')[0]

    originalInputValue = input_div.attr('data-original-value')
    # don't bother to do anything if there is no text in the input.
    if originalInputValue == undefined
      return

    input_field.value = originalInputValue

    charLength = ( input_field.scrollWidth / originalInputValue.length )
    numVisibleChars = Math.round(input_field.clientWidth / charLength)


    if input_field.scrollWidth > input_field.clientWidth
      # overflow
      partSize = ( numVisibleChars / 2 ) - 2
      shownValue = originalInputValue.substring(0, partSize) + ' ... ' +
                   originalInputValue.substring(
                     originalInputValue.length - partSize + 2, originalInputValue.length)

      # remember that the original value is stored in the input_div's 'data-original-value' attribute
      input_field.value = shownValue

    else
      input_field.value = originalInputValue

  # --------------------------------------------------------------------------------------------------------------------
  # Caret functions
  # --------------------------------------------------------------------------------------------------------------------

  @setSelectionRange = (input, selectionStart, selectionEnd) ->
    if input.setSelectionRange
      input.focus()
      input.setSelectionRange(selectionStart, selectionEnd)
    else if input.createTextRange
      range = input.createTextRange()
      range.collapse(true)
      range.moveEnd('character', selectionEnd)
      range.moveStart('character', selectionStart)
      range.select()

  @setCaretToPos = (input, pos)->
    ButtonsHelper.setSelectionRange(input, pos, pos)

  @getCaret = (el)->
    if el.selectionStart
      return el.selectionStart
    else if document.selection
      el.focus()

      r = document.selection.createRange()
      if r == null
        return 0

      re = el.createTextRange()
      rc = re.duplicate()
      re.moveToBookmark(r.getBookmark())
      rc.setEndPoint('EndToStart', re)

      return rc.text.length
    return 0

  # --------------------------------------------------------------------------------------------------------------------
  # expandable text input
  # --------------------------------------------------------------------------------------------------------------------

  class @ExpandableInput

    @CURRENT_ID = 0

    constructor:(input_element)->
      if not input_element instanceof jQuery
        @$input_element = $(input_element)
      else
        @$input_element = $(input_element)
      @expanded_area_id = 'expandable-input-'+ButtonsHelper.ExpandableInput.CURRENT_ID
      ButtonsHelper.ExpandableInput.CURRENT_ID += 1
      if not @$input_element.is("input")
        throw new Error("WARNING: could not obtain a valid input element to create an expandable input.")


      @$input_element.after(
        '<textarea id="'+@expanded_area_id+'" class="buttons-helper-expandable-input">'
      )
      @initial_width = Math.ceil(@$input_element.width())
      @initial_height = Math.ceil(@$input_element.height())
      @$expandend_element = $('#'+@expanded_area_id)
      @$input_element.keyup(@onkeyup.bind(@))
      @$input_element.focus(@onfocus.bind(@))
      @$expandend_element.keyup(@expandedKeyup.bind(@))
      @$expandend_element.blur(@expandedBlur.bind(@))
      @real_value = null
      @val(@$input_element.val())
      # on enter callback
      @on_enter_cb = null
      thisObject = @
      $(window).resize ->
        thisObject.$input_element.width('')

    val: (new_value)->
      if _.isUndefined(new_value)
        return @real_value
      else
        @real_value = new_value
        @compressInput()

    getCompressedString: ()->
      if @isInputOverflowing()
        char_length = ( @$input_element[0].scrollWidth/@real_value.length )
        num_visible_chars = Math.round(@$input_element[0].clientWidth/char_length)
        ellipsis = '  .  .  .  '
        part_size = (num_visible_chars - ellipsis.length)/ 2
        compressed = @real_value.substring(0, part_size) + ellipsis +
          @real_value.substring(@real_value.length - part_size, @real_value.length)
        return compressed

      else
        return @real_value

    decompressInput: ()->
      # This is required to reset the values of scrollWidth and clientWidth to check if text is overflowing
      @initial_width = Math.ceil(@$input_element.width())
      if @initial_width > 0
        @$input_element.width(@initial_width)
        @$input_element.val(@real_value)

    compressInput: ()->
      @decompressInput()
      if @isInputOverflowing()
        @$input_element.val(@getCompressedString())

    updateVals: (toArea)->
      if toArea
        @$expandend_element.val(@real_value)
      else
        @$input_element.val(@real_value)

    isInputOverflowing: ()->
      return (@$input_element[0].scrollWidth > @$input_element[0].clientWidth)

    adjustExpandedHeight: ()->
      max_height = $(window).height()*0.8
      # This is done to include the case in which by deleting text the scroll height remains larger than the actual
      # text inside the text area
      @$expandend_element.height(@initial_height)
      text_h = @$expandend_element[0].scrollHeight-(@$expandend_element.innerHeight()-@$expandend_element.height())
      min_h = Math.min(max_height,text_h)
      @$expandend_element.height(min_h)

    # This calculation works only if the input is being displayed if display:none is active it will not work
    showIfInputOverflows: (select_all)->
      @updateVals(true)
      if @isInputOverflowing()
        caret_pos = ButtonsHelper.getCaret(@$input_element[0])
        @$input_element.hide()
        @$expandend_element.show()
        @$expandend_element.focus()
        if select_all
          @$expandend_element[0].select()
        else
          ButtonsHelper.setCaretToPos(@$expandend_element[0],caret_pos)
        @adjustExpandedHeight()

    onkeyup: (e)->
      @real_value = @$input_element.val()
      @handleEnter(e,false)
      @showIfInputOverflows(false)

    onfocus: ()->
      @decompressInput()
      @showIfInputOverflows(true)

    expandedKeyup: (e)->
      @real_value = @$expandend_element.val()
      @handleEnter(e,true)
      @adjustExpandedHeight()

    expandedBlur: ()->
      @updateVals(false)
      @$expandend_element.hide()
      @$input_element.show()
      @compressInput()

    onEnter:(callback)->
      if not _.isUndefined(callback)
        @on_enter_cb = callback

    handleEnter: (event, blur_expanded)->
      if event.which == 13 and @on_enter_cb
        @on_enter_cb()
      if event.which == 13 and blur_expanded
        @$expandend_element.blur()


  @createExpandableInput = (input_element)->
    return new ButtonsHelper.ExpandableInput(input_element)

  # --------------------------------------------------------------------------------------------------------------------
  # Scrolling
  # --------------------------------------------------------------------------------------------------------------------

  @disableScroll = (jQueryElement)->
    jQueryElement.css('overflow-y', 'hidden')

  @enableScroll = (jQueryElement)->
    jQueryElement.css('overflow-y', 'auto')

  @disableOuterScrollOnMouseEnter= (element, outerElement) ->
    s = { insideIFrame: false }
    $(element).mouseenter ->
      s.insideIFrame = true
      ButtonsHelper.disableScroll($(outerElement))
    $(element).mouseleave ->
      s.insideIFrame = false
      ButtonsHelper.enableScroll($(outerElement))





