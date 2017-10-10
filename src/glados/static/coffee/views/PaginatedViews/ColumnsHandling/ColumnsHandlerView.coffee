glados.useNameSpace 'glados.views.PaginatedViews.ColumnsHandling',
  ColumnsHandlerView: Backbone.View.extend

    initialize: ->

      @modalId = (new Date()).getTime()
      @render()
      @model.on 'change:visible_columns', @renderModalContent, @
      @model.on glados.models.paginatedCollections.ColumnsHandler.EVENTS.COLUMNS_ORDER_CHANGED, @renderModalContent, @

    events:
      'click .BCK-show-hide-column': 'showHideColumn'

    render: ->

      @renderModalTrigger()
      @renderModalContent()

    renderModalTrigger: ->

      glados.Utils.fillContentForElement $(@el).find('.BCK-ModalTrigger'),
        modal_id: @modalId

    renderModalContent: ->

      allColumns = @model.get('all_columns')

      glados.Utils.fillContentForElement $(@el).find('.BCK-ModalContent'),
        all_selected: _.reduce((col.show for col in allColumns), (a,b) -> a and b)
        random_num: (new Date()).getTime()
        all_columns: allColumns

      @initDragging()

      @hidePreloader()
      thisView = @
      _.defer ->
        thisView.hidePreloader()

    showHideColumn: (event) ->

      $checkbox = $(event.currentTarget)
      colComparator = $checkbox.attr('data-comparator')
      isChecked = $checkbox.is(':checked')

      thisView = @

      if colComparator == 'SELECT-ALL'
        thisView.model.setShowHideAllColumnStatus(isChecked)
      else
        thisView.model.setShowHideColumnStatus(colComparator, isChecked)

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
      allColumnsIndex = @.model.get('columns_index')

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



