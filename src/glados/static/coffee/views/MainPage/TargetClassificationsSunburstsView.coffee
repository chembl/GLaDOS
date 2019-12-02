glados.useNameSpace 'glados.views.MainPage',
  TargetClassificationsSunburstsView: Backbone.View.extend

    CLASSIFICATION_TREES:
      protein_classification:
        label: 'Protein Target Tree'
        classification_type: glados.models.visualisation.TargetClassification.Types.PROTEIN_CLASSIFICATION
      organism_taxonomy:
        label: 'Organism Taxonomy'
        classification_type: glados.models.visualisation.TargetClassification.Types.ORGANISM_TAXONOMY
        selected: true
      gene_ontology:
        label: 'Gene Ontology'
        classification_type: glados.models.visualisation.TargetClassification.Types.GENE_ONTOLOGY

    events:
      'change .BCK-TreeSelect': 'selectTree'

    initialize: ->

      @config = arguments[0].config
      @render()

    render: ->

      $selector = $(@el).find('.BCK-TreeSelect')

      selectorParams =
        options: []

      selectedTree = undefined
      for treeID, treeDesc of @CLASSIFICATION_TREES
        newOption =
          value: treeID
          label: treeDesc.label
          is_selected: treeDesc.selected == true

        if treeDesc.selected == true
          selectedTree = treeID

        selectorParams.options.push(newOption)

      glados.Utils.fillContentForElement($selector, selectorParams)
      $selector.material_select()

      @showCardContent()
      @showTree(selectedTree)

    showCardContent: ->

      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()

    selectTree: (event) ->

      $paramElem = $(event.target)
      value = $paramElem.val()
      @showTree(value)

    showTree: (treeKey) ->

      treeDesc = @CLASSIFICATION_TREES[treeKey]
      viewElementID = treeDesc.viewElementID

      if not viewElementID?

        $viewContainer = $(@el).find('.BCK-sunbursts-container')
        viewElementID = "Sunburst-#{treeKey}-#{Math.floor((Math.random() * 10000) + 1)}"
        templateID = 'Handlebars-Sunburst-container'
        $sunburstElem = $('<div>')
          .attr('id', viewElementID)
          .attr('data-hb-template', templateID)
          .css('height', '100%')
          .addClass('BCK-sunburst')
        $sunburstElem.html(glados.Utils.getContentFromTemplate(templateID))
        $viewContainer.append($sunburstElem)
        treeDesc.viewElementID = viewElementID

        proteinClassificationModel = new glados.models.visualisation.TargetClassification
          type: treeDesc.classification_type

        view = new glados.views.MainPage.ZoomableSunburstView
          el: $sunburstElem
          config: @config
          model: proteinClassificationModel

        proteinClassificationModel.fetch()

      $allSunbursts = $(@el).find('.BCK-sunburst')
      $allSunbursts.hide()
      $sunburstElem = $(@el).find("##{viewElementID}")
      $sunburstElem.show()
