glados.useNameSpace 'glados.views.PaginatedViews.ColumnsHandling',
  ColumnsHandlerView: Backbone.View.extend

    initialize: ->
      console.log 'init Columns handler view'
      @render()

    events:
      'click .BCK-show-hide-column': 'showHideColumn'

    render: ->
      console.log 'render columns handler view'

      allColumns = @model.get('all_columns')

      glados.Utils.fillContentForElement $(@el),
        all_selected: true
        modal_id: $(@el).attr('id') + '-select-columns-modal'
        random_num: (new Date()).getTime()
        all_columns: allColumns

    showHideColumn: (event) ->

      console.log 'SHOW HIDE COLUMN'
      return
      $checkbox = $(event.currentTarget)
      colComparator = $checkbox.attr('data-comparator')
      isChecked = $checkbox.is(':checked')

      allColumns = _.union(@collection.getMeta('columns'), @collection.getMeta('additional_columns'))

      if colComparator == 'SELECT-ALL'
        for col in allColumns
          col.show = isChecked
      else
        changedColumn = _.find(allColumns, (col) -> col.comparator == colComparator)
        changedColumn.show = isChecked

      @clearTemplates()
      @fillTemplates()