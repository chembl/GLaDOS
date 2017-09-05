glados.useNameSpace 'glados.views.Compound',
  DeferredStructureView: Backbone.View.extend
    initialize: ->

      @renderSimilarityMap()

    renderSimilarityMap: ->

      if @model.get('loading_similarity_map')
       @showPreloader()

    showPreloader: ->

      if not $(@el).attr('data-preloader-added') != 'yes'
        $newPreloader = $(glados.Utils.getContentFromTemplate('Handlebars-Common-MiniRepCardPreloader'))
        $(@el).append($newPreloader)
        $(@el).attr('data-preloader-added', 'yes')

      $image = $(@el).find('img')
      $image.hide()

