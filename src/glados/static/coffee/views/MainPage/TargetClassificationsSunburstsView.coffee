glados.useNameSpace 'glados.views.MainPage',
  TargetClassificationsSunburstsView: Backbone.View.extend

    CLASSIFICATION_TREES:
      protein_classification:
        label: 'Protein Target Tree'
        selected: true
      organism_taxonomy:
        label: 'Organism Taxonomy'
      gene_ontology:
        label: 'Gene Ontology'

    events:
      'change .BCK-TreeSelect': 'selectTree'

    initialize: ->

      @config = arguments[0].config
      console.log('INIT CLASS SUNBURST VIEW')
      @render()

    render: ->

      $selector = $(@el).find('.BCK-TreeSelect')
      console.log('$selector: ', $selector)

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

      @showTree(treeID)

      glados.Utils.fillContentForElement($selector, selectorParams)
      $selector.material_select()

      @showCardContent()

#      proteinClassificationModel = new glados.models.visualisation.TargetClassification
#      type: glados.models.visualisation.TargetClassification.Types.GENE_ONTOLOGY


#      config =
#        browse_all_link: "#{glados.Settings.GLADOS_BASE_URL_FULL}/g/#browse/targets"
#        browse_button: true
#        browse_button_container: $browseButtonContainer
#
#      view = new glados.views.MainPage.ZoomableSunburstView
#        el: $('#BCK-zoomable-sunburst')
#        model: proteinClassificationModel
#        config: config
#
#      proteinClassificationModel.fetch()


    showCardContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()

    selectTree: (event) ->

      $paramElem = $(event.target)
      value = $paramElem.val()
      @showTree(value)

    showTree: (treeKey) ->

      console.log('showTree: ', treeKey)
      treeDesc = @CLASSIFICATION_TREES[treeKey]
      viewElementID = treeDesc.viewElementID

      if not viewElementID?

        $viewContainer = $(@el).find('.BCK-sunbursts-container')
        viewElementID = "Sunburst-#{treeKey}-#{Math.floor((Math.random() * 10000) + 1)}"
        console.log('viewElementID: ', viewElementID)
        templateID = 'Handlebars-Sunburst-container'
        $sunburstElem = $('<div>').attr('id', viewElementID).attr('data-hb-template', templateID)
          .addClass('BCK-sunburst')
        $sunburstElem.html(glados.Utils.getContentFromTemplate(templateID, {name: treeKey}))
        $viewContainer.append($sunburstElem)
        treeDesc.viewElementID = viewElementID

      $allSunbursts = $(@el).find('.BCK-sunburst')
      $allSunbursts.hide()
      $sunburstElem = $(@el).find("##{viewElementID}")
      $sunburstElem.show()
