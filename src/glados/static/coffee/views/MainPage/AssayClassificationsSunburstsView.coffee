glados.useNameSpace 'glados.views.MainPage',
  AssayClassificationsSunburstsView: Backbone.View.extend

    CLASSIFICATION_TREES:
      in_vivo:
        label: 'In vivo assays'
        classification_type: glados.models.visualisation.AssayClassificationModel.Types.IN_VIVO
        selected: true

    initialize: ->

      @config = arguments[0].config
      @render()

    showCardContent: ->

      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()

    render: ->

      @showCardContent()

      treeKey = 'in_vivo'
      treeDesc = @CLASSIFICATION_TREES[treeKey]
      viewElementID = treeDesc.viewElementID

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

      assayClassificationModel = new glados.models.visualisation.AssayClassificationModel
        type: treeDesc.classification_type

      view = new glados.views.MainPage.ZoomableSunburstView
          el: $sunburstElem
          config: @config
          model: assayClassificationModel

      $sunburstElem.show()

      assayClassificationModel.fetch()