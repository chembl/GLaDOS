BrowseTargetAsListView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @render, @

  showPreloader: ->

    $(@el).find('.preloader-container').show()

    table = $(@el).find('.tree')
    table.hide()

  hidePreloader: ->


    $(@el).find('.preloader-container').hide()

    table = $(@el).find('.tree')
    table.show()


  render: ->

    all_nodes = @model.get('all_nodes')
    table = $(@el).find('.tree')
    table.empty()

    for node in all_nodes.models

      indentator = [1..node.get('depth')]
      indentator.pop()


      new_row = Handlebars.compile($('#Handlebars-TargetBrowser-AsList-item').html())
        id: node.get('id')
        name: node.get('name')
        size: node.get('size')
        # this is because handlebars doesn't have simple for loops
        indent: indentator
        is_leaf: node.get('is_leaf')

      new_elem = $(new_row).attr('id', 'rowFor' + node.get('id'))
      table.append(new_elem)

      if node.get('show') == true
          new_elem.show()
      else
        new_elem.hide()

      newView = new BrowseTargetAsListNodeView
        model: node
        el: new_elem



    @hidePreloader()


  expandAll: ->
    @model.expandAll()

  collapseAll: ->
    @model.collapseAll()

  selectAll: ->
    @model.selectAll()

  clearSelections: ->
    @model.clearSelections()

