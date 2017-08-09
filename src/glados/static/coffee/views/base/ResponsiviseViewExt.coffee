# This is a base object to help responsivise a view with a complex visualization such as d3,
# extend a view in backbone with this object
# to get the functionality for resizing visualizations when the page size changes.
# this way allows to easily handle multiple inheritance in the models.
ResponsiviseViewExt =


  updateView: (debounced_render, emptyBeforeRender=true) ->

    if emptyBeforeRender
      if @$vis_elem?
        $to_empty = @$vis_elem
      else
        $to_empty = $(@el)

      $to_empty.empty()

    @showResponsiveViewPreloader(emptyBeforeRender)
    debounced_render()

  # this also binds the resize event with the repaint event.
  setUpResponsiveRender: (emptyBeforeRender=true) ->

    # the render function is debounced so it waits for the size of the
    # element to be ready
    reRender = ->
      @IS_RESPONSIVE_RENDER = true
      @render()
      @IS_RESPONSIVE_RENDER = false
      @hideResponsiveViewPreloader(emptyBeforeRender)

    debouncedRender = _.debounce($.proxy(reRender, @), glados.Settings.RESPONSIVE_REPAINT_WAIT)
    updateViewProxy = $.proxy(@updateView, @, debouncedRender, emptyBeforeRender)

    $(window).resize ->
      updateViewProxy()

    return updateViewProxy

  showResponsiveViewPreloader: (emptyBeforeRender=true) ->

    if not emptyBeforeRender
      @showPreloader()
      return

    if @$vis_elem?
      $base_elem = @$vis_elem
    else
      $base_elem = $(@el)

    if $base_elem.attr('data-loading') == 'false' or !$base_elem.attr('data-loading')?
      $base_elem.html Handlebars.compile($('#Handlebars-Common-Preloader').html())
      $base_elem.attr('data-loading', 'true')

  hideResponsiveViewPreloader: (emptyBeforeRender=true) ->

    if not emptyBeforeRender
      @hidePreloader()
      return

    if @$vis_elem?
      $base_elem = @$vis_elem
    else
      $base_elem = $(@el)


    $base_elem.find('.card-preolader-to-hide').hide()
    $base_elem.attr('data-loading', 'false')