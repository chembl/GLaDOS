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


    console.log(@collection)

    for drug in @collection.getCurrentPage()

      new_row_cont = Handlebars.compile( template.html() )
        molecule_chembl_id: drug.get('molecule_chembl_id')
        molecule_type: drug.get('molecule_type')
        pref_name: drug.get('pref_name')
        max_phase: drug.get('max_phase')

      elem.append($(new_row_cont))

      console.log('add row!')

  clearTable: ->

    $('#DBTable-large').empty()