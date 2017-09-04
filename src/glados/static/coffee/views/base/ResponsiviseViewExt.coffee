# This is a base object to help responsivise a view with a complex visualization such as d3,
# extend a view in backbone with this object
# to get the functionality for resizing visualizations when the page size changes.
# this way allows to easily handle multiple inheritance in the models.
ResponsiviseViewExt =


  updateView: (debounced_render, emptyBeforeRender=true) ->

    if emptyBeforeRender
      @getVisElem().empty()

    if not @getVisElem().is(":visible")
      return

    @showResponsiveViewPreloader(emptyBeforeRender)
    debounced_render()

  # this also binds the resize event with the repaint event.
  setUpResponsiveRender: (emptyBeforeRender=true) ->

    @originalRender = $.proxy(@render, @)
    renderIfResizeStopped = $.proxy((->
      newWidth = @getVisElem().width()

      if newWidth != @currentElemWidth
        @currentElemWidth = newWidth
        setTimeout(renderIfResizeStopped, glados.Settings.RESPONSIVE_SIZE_CHECK_WAIT)
      else
        @IS_RESPONSIVE_RENDER = true
        @originalRender()
        @hideResponsiveViewPreloader(emptyBeforeRender)
        @IS_RESPONSIVE_RENDER = false
    ), @)

    # the render function is debounced so it waits for the size of the
    # element to be ready
    reRender = ->

      @currentElemWidth = @getVisElem().width()
      setTimeout(renderIfResizeStopped, glados.Settings.RESPONSIVE_SIZE_CHECK_WAIT)

    debouncedRender = _.debounce($.proxy(reRender, @), glados.Settings.RESPONSIVE_REPAINT_WAIT)
    @render = debouncedRender
    updateViewProxy = $.proxy(@updateView, @, debouncedRender, emptyBeforeRender)

    $(window).resize ->
      updateViewProxy()

    return updateViewProxy

  showResponsiveViewPreloader: (emptyBeforeRender=true) ->

    if not emptyBeforeRender
      @showPreloader()
      return


    $base_elem = @getVisElem()

    if $base_elem.attr('data-loading') == 'false' or !$base_elem.attr('data-loading')?
      $base_elem.html Handlebars.compile($('#Handlebars-Common-Preloader').html())
      $base_elem.attr('data-loading', 'true')

  hideResponsiveViewPreloader: (emptyBeforeRender=true) ->

    if not emptyBeforeRender
      @hidePreloader()
      return

    $baseElem = @getVisElem()
    $baseElem.find('.card-preolader-to-hide').hide()
    $baseElem.attr('data-loading', 'false')

  getVisElem: -> if @$vis_elem? then @$vis_elem else $(@el)
