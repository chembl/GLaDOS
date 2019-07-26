glados.useNameSpace 'glados.views.PaginatedViews.ColumnsHandling',
  ColumnsHandlerView: Backbone.View.extend

    initialize: ->

      @modalId = arguments[0].modal_id
      @modalId ?= (new Date()).getTime()
      @facetsMode = arguments[0].facets_mode
      @render()

      if @facetsMode
        @model.on glados.models.paginatedCollections.FacetGroupVisibilityHandler.EVENTS.COLUMNS_SHOW_STATUS_CHANGED,\
          @renderModalContent, @
      else
        @model.on 'change:visible_columns', @renderModalContent, @

      @model.on glados.models.paginatedCollections.ColumnsHandler.EVENTS.COLUMNS_ORDER_CHANGED, @renderModalContent, @

    events:
      'click .BCK-show-hide-column': 'showHideColumn'

    render: ->
      @renderModalContent()

    getAllColumnsFromFacets: -> @model.getAllFacetsGroupsAsList()

    prepareFacetListForView: (facetsList) ->

      for fGroup in facetsList
        fGroup.comparator = fGroup.key
        fGroup.name_to_show = fGroup.label

    renderModalContent: ->

      if @facetsMode
        allColumns = @getAllColumnsFromFacets()
        @prepareFacetListForView(allColumns)

      else
        allColumns = @model.get('all_columns')

      # handlebars can't acces variables outside of scope. :(
      for col in allColumns
        col.modal_id = @modalId

      glados.Utils.fillContentForElement $(@el),
        all_selected: _.reduce((col.show for col in allColumns), (a,b) -> a and b)
        random_num: (new Date()).getTime()
        all_columns: allColumns
        modal_id: @modalId

      # handlebars can't acces variables outside of scope. :(
      for col in allColumns
        col.modal_id = undefined

      @initDragging()
      $propertyItems = $(@el).find('.BCK-propertyItem')
      $propertyItems.one 'mouseover', ->
        if @offsetWidth < @scrollWidth
          $elem = $(@)
          if $elem.data('tooltip-set-up') != 'yes'
            qtipConfig =
              content:
                text: @textContent
              show:
                ready: true
                solo: true
              style:
                classes:'qtip-light qtip-shadow'
              position: glados.Utils.Tooltips.getQltipSafePostion($elem)

            $elem.qtip qtipConfig
            $elem.data('tooltip-set-up', 'yes')

      @hidePreloader()

    showHideColumn: (event) ->

      $checkbox = $(event.currentTarget)
      colID = $checkbox.attr('data-prop-id')
      isChecked = $checkbox.is(':checked')

      thisView = @

      if @facetsMode

        if colID == 'SELECT-ALL'
          thisView.model.setShowHideAllFGroupStatus(isChecked)
        else
          thisView.model.setShowHideFGroupStatus(colID, isChecked)

      else

        if colID == 'SELECT-ALL'
          thisView.model.setShowHideAllColumnStatus(isChecked)
        else
          thisView.model.setShowHideColumnStatus(colID, isChecked)

    showPreloader: ->$(@el).find('.BCK-loading-cover').show()
    hidePreloader: -> $(@el).find('.BCK-loading-cover').hide()

    #-------------------------------------------------------------------------------------------------------------------
    # Drag and drop
    #-------------------------------------------------------------------------------------------------------------------
    initDragging: ->

      $draggableElems = $(@el).find('.BCK-draggable')
      $draggableElemsContainer = $(@el).find('.BCK-draggable-container')
      $dragDummies = $(@el).find('.BCK-drag-dummy')

      thisView = @

      $draggableElems.each ->
        @addEventListener 'dragstart', (e) ->
          e.dataTransfer.setData('text', 'fix for firefox')

      $draggableElems.on 'drag', ->

        $draggedElem = $(@)
        propertyName = $draggedElem.attr('data-comparator')
        thisView.property_being_dragged = propertyName

      $draggableElems.on 'dragenter', ->

        $draggedOver = $(@)
        propertyName = $draggedOver.attr('data-comparator')
        propertyBeingDragged = thisView.property_being_dragged
        thisView.property_receiving_drag = propertyName

        if propertyName != propertyBeingDragged
          $draggedElem = $draggableElemsContainer.find('.BCK-draggable[data-comparator="' + propertyBeingDragged + '"]')
          $draggedElem.addClass('being-dragged')
          $draggedOver.addClass('dragged-over')
          $dragDummy = $draggableElemsContainer.find('.BCK-drag-dummy[data-comparator="' + propertyName + '"]')
          $dragDummy.addClass('show')
          $dragDummy.text(thisView.model.getPropertyLabel(propertyBeingDragged))

        $restOfElements = $draggableElemsContainer.find(':not([data-comparator="' + propertyName + '"])')
        $restOfElements.removeClass('dragged-over')
        $restOfElements.removeClass('show')

      $draggableElems.on 'dragend', (event) ->

        $draggedElem = $(@)
        $draggedElem.removeClass('being-dragged')
        $draggableElems.removeClass('dragged-over')
        $dragDummies.removeClass('show')

        propertyReceivingDrag = thisView.property_receiving_drag
        propertyBeingDragged = thisView.property_being_dragged

        if propertyReceivingDrag != propertyBeingDragged
          thisView.model.changeColumnsOrder(propertyReceivingDrag, propertyBeingDragged)



