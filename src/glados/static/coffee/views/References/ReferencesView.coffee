glados.useNameSpace 'glados.views.References',
  ReferencesView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @

    render: ->

      references = @model.get('_metadata').unichem
      refsIndex = _.groupBy(references, 'src_name')

      refsGroups = []
      for refKey, refsList of refsIndex
        refsGroups.push
          src_name: refKey
          src_url: refsList[0].src_url
          ref_items: refsList
          active: false

      refsGroups.sort (a, b) -> a.src_name.localeCompare(b.src_name)
      refsGroups[0].active = true

      referencesContainer = $(@el)
      glados.Utils.fillContentForElement referencesContainer,
        references_groups: refsGroups

      $(@el).find('.collapsible').collapsible()