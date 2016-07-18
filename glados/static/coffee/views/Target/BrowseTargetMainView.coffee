BrowseTargetMainView = Backbone.View.extend

  events:
   'click .open-all': 'openAll'
   'click .collapse-all': 'collapseAll'
   'click .select-all': 'selectAll'
   'click .clear-selections': 'clearSelections'
   'change input[name="selectTree"]': 'selectTree'
   'click .search-in-tree': 'searchInTree'

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

    @listView.showPreloader()
    @circlesView.showPreloader()

    @model.fetch()

  searchInTree: ->

    searchTerms = $(@el).find('#search_terms').val()

    numFound = @model.searchInTree(searchTerms)

    $(@el).find('#search_in_tree_summary').html Handlebars.compile($('#Handlebars-TargetBrowser-searchResults').html())
      num_results: numFound







