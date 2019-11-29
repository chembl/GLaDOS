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

    initialize: ->

      @config = arguments[0].config
      console.log('INIT CLASS SUNBURST VIEW')
      @render()

    render: ->

      $selector = $(@el).find('.BCK-ParamSelect')
      console.log('$selector: ', $selector)

      selectorParams =
        options: []

      for treeID, treeDesc of @CLASSIFICATION_TREES
        newOption =
          value: treeID
          label: treeDesc.label
          is_selected: treeDesc.selected == true

        selectorParams.options.push(newOption)

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


