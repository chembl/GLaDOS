glados.useNameSpace 'glados.views.References',
  ReferencesView: Backbone.View.extend
    initialize: ->
      @config = arguments[0].config
      @model.on 'change', @render, @

    render: ->

      refsGroups = []
      refsFilter = @config.filter

      if @config.is_unichem
        references = @model.get('_metadata').unichem
        if not references?
          @renderWhenNoRefs()
          return

        refsIndex = _.groupBy(references, 'src_name')

        for refKey, refsList of refsIndex
          refsGroups.push
            src_name: refKey
            src_url: refsList[0].src_url
            ref_items: refsList

      else

        references = @model.get('cross_references')

        if not references?
          @renderWhenNoRefs()
          return

        if refsFilter?
          references = _.filter(references, refsFilter)

        if references.length == 0
          @renderWhenNoRefs()
          return

        refsIndex = _.groupBy(references, 'xref_src')

        for refKey, refsList of refsIndex

          for ref in refsList
            ref.src_url = ref.xref_src_url
            ref.link = ref.xref_url
            ref.id = ref.xref_name
            ref.id ?= ref.xref_id
            ref.is_atc = refKey == 'ATC'
            ref.vertical_list = refKey in ['GoComponent']

          refsGroups.push
            src_name: refKey
            src_url: refsList[0].xref_src_url
            ref_items: refsList

      refsGroups.sort (a, b) -> a.src_name.localeCompare(b.src_name)

      referencesContainer = $(@el)
      glados.Utils.fillContentForElement referencesContainer,
        references_groups: refsGroups

    renderWhenNoRefs: ->

      referencesContainer = $(@el)
      glados.Utils.fillContentForElement referencesContainer, {
        is_unichem: @config.is_unichem
        chembl_id: @model.get('id')
        },
        'Handlebars-Common-No-References'
