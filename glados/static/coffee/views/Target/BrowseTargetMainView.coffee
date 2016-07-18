BrowseTargetMainView = Backbone.View.extend

  events:
   'click .open-all': 'openAll'
   'click .collapse-all': 'collapseAll'
   'click .select-all': 'selectAll'
   'click .clear-selections': 'clearSelections'
   'change input[name="selectTree"]': 'selectTree'

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

    @model.fetch()








