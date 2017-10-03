glados.useNameSpace 'glados.views.PaginatedViews.ColumnsHandling',
  ColumnsHandlerView: Backbone.View.extend

    initialize: ->

      @modalId = (new Date()).getTime()
      @render()
      @model.on 'change:visible_columns', @renderModalContent, @

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

    showHideColumn: (event) ->

      $checkbox = $(event.currentTarget)
      colComparator = $checkbox.attr('data-comparator')
      isChecked = $checkbox.is(':checked')

      if colComparator == 'SELECT-ALL'
        @model.setShowHideAllColumnStatus(isChecked)
      else
        @model.setShowHideColumnStatus(colComparator, isChecked)
