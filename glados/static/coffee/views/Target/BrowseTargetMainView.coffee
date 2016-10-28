BrowseTargetMainView = Backbone.View.extend

  events:
   'click .open-all': 'openAll'
   'click .collapse-all': 'collapseAll'
   'click .select-all': 'selectAll'
   'click .clear-selections': 'clearSelections'
   'change input[name="selectTree"]': 'selectTree'
   'click .search-in-tree': 'searchInTree'
   'click .reset-search': 'resetSearch'

  initialize: ->

    @listView = TargetBrowserApp.initBrowserAsList(@model, $('#BCK-TargetBrowserAsList'))
    @circlesView = TargetBrowserApp.initBrowserAsCircles(@model, $('#BCK-TargetBrowserAsCircles'))

  openAll: ->
    @listView.expandAll()

  collapseAll: ->
    @listView.collapseAll()

  selectAll: ->

    @listView.selectAll()

  clearSelections: ->

    @listView.clearSelections()

  selectTree: ->

    btnCheckedID = $(@el).find('input[name="selectTree"]:checked').attr('id')

    url = switch btnCheckedID
      when 'radio-proteinTargetTree'
        @model.url = 'static/data/protein_target_tree.json'
      when 'radio-taxonomyTree'
        @model.url = 'static/data/taxonomy_target_tree.json'
      when 'radio-geneOntologyTree'
        @model.url = 'static/data/gene_ontology_tree.json'

    @listView.showPaginatedViewPreloader()
    @circlesView.showPaginatedViewPreloader()

    @model.fetch()

  searchInTree: ->

    searchTerms = $(@el).find('#search_terms').val()
    search_summary = $(@el).find('#search_in_tree_summary')
    search_summary.show()

    if searchTerms.length < 2
      search_summary.html 'You must enter at least to characters'
      return

    numFound = @model.searchInTree(searchTerms)

    search_summary.html Handlebars.compile($('#Handlebars-TargetBrowser-searchResults').html())
      num_results: numFound


  resetSearch: ->

    search_summary = $(@el).find('#search_in_tree_summary')
    search_summary.hide()
    @model.resetSearch()





