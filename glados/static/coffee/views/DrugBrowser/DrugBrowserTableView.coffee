# View that renders the drug browser as a paginated table.
DrugBrowserTableView = Backbone.View.extend(PaginatedViewExt).extend

  initialize: ->
    @collection.on 'reset do-repaint sort', @.render, @

  render: ->
    console.log('render!')
    @clearTable()
    @fill_template('DBTable-large')

  fill_template: (elem_id) ->

    elem = $(@el).find('#' + elem_id)
    template = $('#' + elem.attr('data-hb-template'))

    if elem.is('table')

      header_template = $('#' + elem.attr('data-hb-template-2'))
      header_row_cont = Handlebars.compile( header_template.html() )
        columns: @collection.getMeta('columns')

      elem.append($(header_row_cont))

    for item in @collection.getCurrentPage()

      columns_val = @collection.getMeta('columns').map (col) ->
        col['value'] = item.get(col.comparator)
        col['has_link'] = col.link_base?
        col['link_url'] = col['link_base'].replace('$$$', col['value']) unless !col['has_link']

      new_row_cont = Handlebars.compile( template.html() )
        columns: @collection.getMeta('columns')

      elem.append($(new_row_cont))


  clearTable: ->

    $('#DBTable-large').empty()