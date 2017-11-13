glados.useNameSpace 'glados.views.References',
  ReferencesView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @

    render: ->

      references = [
        {
          id: 'DB00945'
          src_name: 'DrugBank'
          url: 'http://www.drugbank.ca/drugs/DB00945'
          src_url: 'http://www.drugbank.ca/'
        }
        {
          id: 'aspirin'
          src_name: 'Atlas'
          url: 'http://www.ebi.ac.uk/gxa/query?conditionQuery=aspirin'
          src_url: 'http://www.ebi.ac.uk/gxa/home'
        }
        {
          id: 'acetylsalicylic acid'
          src_name: 'Atlas'
          url: 'http://www.ebi.ac.uk/gxa/query?conditionQuery=acetylsalicylic acid'
          src_url: 'http://www.ebi.ac.uk/gxa/home'
        }
      ]

      refsIndex = _.groupBy(references, 'src_name')
      console.log 'AAA refsIndex: ', refsIndex

      refsGroups = []
      for refKey, refsList of refsIndex
        refsGroups.push
          src_name: refKey
          src_url: refsList[0].src_url
          ref_items: refsList

      console.log 'AAA refsGroups: ', refsGroups

      referencesContainer = $(@el)
      glados.Utils.fillContentForElement referencesContainer,
        references_groups: refsGroups

      $(@el).find('.collapsible').collapsible()