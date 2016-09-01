# This is a base object to help responsivise a view with a complex visualization such as d3,
# extend a view in backbone with this object
# to get the functionality for resizing visualizations when the page size changes.
# this way allows to easily handle multiple inheritance in the models.
ResponsiviseViewExt =


  updateView: (debounced_render) ->
    $(@el).empty()
    @showPreloader()
    debounced_render()


  # this also binds the resize event with the repaint event.
  setUpResponsiveRender: ->

    # the render function is debounced so it waits for the size of the
    # element to be ready
    debounced_render = _.debounce($.proxy(@render, @), 300)
    updateViewProxy = $.proxy(@updateView, @, debounced_render)

    $(window).resize ->
      updateViewProxy()

    return updateViewProxy

  showPreloader: ->

    if $(@el).attr('data-loading') == 'false' or !$(@el).attr('data-loading')?
      $(@el).html Handlebars.compile($('#Handlebars-Common-Preloader').html())
      $(@el).attr('data-loading', 'true')
