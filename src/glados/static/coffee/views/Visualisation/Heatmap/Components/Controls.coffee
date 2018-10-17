# This file contains all the functions that are related to the control buttons in the heatmap.
# This includes the controls for:
#  - Sorting rows and columns
# - Colouring cells
# - Zoom functions
# - grabbing
# 
glados.useNameSpace 'glados.views.Visualisation.Heatmap.Components',

  Controls:

    #-------------------------------------------------------------------------------------------------------------------
    # Rendering
    #-------------------------------------------------------------------------------------------------------------------
    paintControls: ->

      @paintSelect('.select-colouring-container',
        (@config.properties[propID] for propID in @config.colour_properties),
        @config.initial_colouring,
        'select-colour-property',
        'Colour by:' )

      @paintSelect('.select-row-sort-container',
        (@config.properties[propID] for propID in @config.row_sorting_properties),
        @config.initial_row_sorting,
        'select-row-sort',
        'Sort rows by:' )

      @paintSelect('.select-col-sort-container',
        (@config.properties[propID] for propID in @config.col_sorting_properties)
        @config.initial_col_sorting,
        'select-col-sort',
        'Sort columns by:' )

      @paintSortDirection('.btn-row-sort-direction-container',
        @config.initial_row_sorting_reverse,
        'row')
      @paintSortDirection('.btn-col-sort-direction-container',
        @config.initial_col_sorting_reverse,
        'col')

      @paintZoomButtons()

      $(@el).find('select').material_select()

    paintZoomButtons: ->

      zoomOptsContent = Handlebars.compile( $('#Handlebars-Common-ESResultsMatrix-ZoomOptions').html() )()

      @$vis_elem.append(zoomOptsContent)

    paintSortDirection: (elemSelector, reverse, target_property) ->

      $sortDirectionBtn = $(@el).find(elemSelector)
      $template = $('#' + $sortDirectionBtn.attr('data-hb-template'))

      if reverse
        $sortDirectionBtn.html Handlebars.compile( $template.html() )
          sort_class: 'fa fa-sort-desc'
          text: 'Desc'
          target_property: target_property
      else
        $sortDirectionBtn.html Handlebars.compile( $template.html() )
          sort_class: 'fa fa-sort-asc'
          text: 'Asc'
          target_property: target_property

    paintSelect: (elemSelector, propsList, defaultValue, customClass, label) ->


      columns = _.map(propsList, (item) ->
        {
          comparator: item.propName
          selected: (item.propName == defaultValue)
          label: item.label
        })

      $select = $(@el).find(elemSelector)
      glados.Utils.fillContentForElement $select,
        custom_class: customClass
        columns: columns
        custom_label: label

    clearControls: ->

      $('.select-colouring-container').empty()
      $('.select-row-sort-container').empty()
      $('.select-col-sort-container').empty()

      $('.btn-row-sort-direction-container').empty()
      $('.btn-col-sort-direction-container').empty()

    #-------------------------------------------------------------------------------------------------------------------
    # Zoom Controls
    #-------------------------------------------------------------------------------------------------------------------
    initResetZoomBtn: -> $(@el).find(".BCK-reset-zoom-btn").click @resetZoom.bind(@)

    zoomInCallback: ->

      #this buttons will always work
      wasDeactivated = not @ZOOM_ACTIVATED
      @ZOOM_ACTIVATED = true

      @zoom.scale( @zoom.scale() + @ZOOM_STEP )
      @mainGContainer.call @zoom.event

      if wasDeactivated
        @ZOOM_ACTIVATED = false

    initZoomInBtn: -> $(@el).find(".BCK-zoom-in-btn").click @zoomInCallback.bind(@)

    zoomOutBtnCallback: ->

      #this buttons will always work
      wasDeactivated = not @ZOOM_ACTIVATED
      @ZOOM_ACTIVATED = true

      @zoom.scale( @zoom.scale() - @ZOOM_STEP )
      @mainGContainer.call @zoom.event

      if wasDeactivated
        @ZOOM_ACTIVATED = false

    initZoomOutBtn: -> $(@el).find(".BCK-zoom-out-btn").click @zoomOutBtnCallback.bind(@)

    #-------------------------------------------------------------------------------------------------------------------
    # Drag Controls
    #-------------------------------------------------------------------------------------------------------------------
    toggleGrabCallback: (event) ->

      $target = $(event.currentTarget)

      $targetBtnIcon = $target.find('i')
      if @ZOOM_ACTIVATED
        @ZOOM_ACTIVATED = false
        $targetBtnIcon.removeClass 'fa-hand-rock-o'
        $targetBtnIcon.addClass 'fa-hand-paper-o'
#        @cellsContainerG.classed('grab-activated', false)
      else
        @ZOOM_ACTIVATED = true
        $targetBtnIcon.removeClass 'fa-hand-paper-o'
        $targetBtnIcon.addClass 'fa-hand-rock-o'
#        @cellsContainerG.classed('grab-activated', true)

    initToggleGrabBtn: -> $(@el).find('.BCK-toggle-grab').click @toggleGrabCallback.bind(@)

    # ------------------------------------------------------------------------------------------------------------------
    # Open in full screen
    # ------------------------------------------------------------------------------------------------------------------
    initFullScreenBtn: ->

      thisView = @
      $(@el).find('.BCK-open-full-screen').click ->
        glados.Utils.URLS.shortenLinkIfTooLongAndOpen(thisView.model.getLinkToFullScreen())

    initColourPropertySelector: ->

      thisView = @
      $(@el).find(".select-colour-property").on "change", () ->

        if !@value?
          return

        thisView.currentPropertyColour = thisView.config.properties[@value]
        thisView.colourCells(thisView.TRANSITIONS_DURATION)

    # ------------------------------------------------------------------------------------------------------------------
    # Row and column sorting
    # ------------------------------------------------------------------------------------------------------------------
    triggerRowSorting: ->

      @model.sortMatrixRowsBy @currentRowSortingProperty.propName, @currentRowSortingPropertyReverse
      @rowsFooterG.positionRows @zoom.scale(), @TRANSITIONS_DURATION
      @rowsFooterG.assignTexts @TRANSITIONS_DURATION
      @cellsContainerG.positionRows @zoom.scale(), @TRANSITIONS_DURATION
      @rowsHeaderG.positionRows @zoom.scale(), @TRANSITIONS_DURATION
      @corner2G.assignTexts()
      # add missing rows in window
      thisView = @
      setTimeout( (-> thisView.handleZoom(ingoreActivation=true, forceSectionsUpdate=true)), thisView.TRANSITIONS_DURATION + 1)

    triggerColSorting: ->

      @model.sortMatrixColsBy @currentColSortingProperty.propName, @currentColSortingPropertyReverse
      @colsFooterG.positionCols @zoom.scale(), @TRANSITIONS_DURATION
      @colsFooterG.assignTexts @TRANSITIONS_DURATION
      @cellsContainerG.positionCols @zoom.scale(), @TRANSITIONS_DURATION
#      @colsHeaderG.positionCols @zoom.scale(), @TRANSITIONS_DURATION
      @corner3G.assignTexts()
      # add missing rows in window
      thisView = @
      setTimeout( (-> thisView.handleZoom(ingoreActivation=true, forceSectionsUpdate=true)), thisView.TRANSITIONS_DURATION + 1)

    initSortRowsBtn: ->

      thisView = @
      $(@el).find(".select-row-sort").on "change", ->

        if !@value?
          return

        thisView.currentRowSortingProperty = thisView.config.properties[@value]
        thisView.triggerRowSorting()

    initSortColBtn: ->

      thisView = @
      $(@el).find(".select-col-sort").on "change", ->

        if !@value?
          return

        thisView.currentColSortingProperty = thisView.config.properties[@value]
        thisView.triggerColSorting()

    handleSortDirClick: (event) ->

      console.log 'handleSortDirClick'
      $target = $(event.currentTarget)

      targetDimension = $target.attr('data-target-property')
      if targetDimension == 'row'

        @currentRowSortingPropertyReverse = !@currentRowSortingPropertyReverse
        @triggerRowSorting()
        @paintSortDirection('.btn-row-sort-direction-container', @currentRowSortingPropertyReverse, 'row')

      else if targetDimension == 'col'

        @currentColSortingPropertyReverse = !@currentColSortingPropertyReverse
        @triggerColSorting()
        @paintSortDirection('.btn-col-sort-direction-container', @currentColSortingPropertyReverse, 'col')

      $(@el).find('.btn-sort-direction').on 'click', @handleSortDirClick.bind(@)

    initSortDirectionBtn: -> $(@el).find('.btn-sort-direction').on 'click', @handleSortDirClick.bind(@)







