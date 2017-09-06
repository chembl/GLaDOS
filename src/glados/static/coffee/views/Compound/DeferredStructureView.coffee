glados.useNameSpace 'glados.views.Compound',
  DeferredStructureView: Backbone.View.extend
    initialize: ->

      @model.on glados.Events.Compound.SIMILARITY_MAP_ERROR, @renderSimilarityMapError, @
      @renderSimilarityMap()

    renderSimilarityMap: ->

      console.log 'AAA renderSimilarityMap'
      if @model.get('loading_similarity_map')
       @showPreloader()
      else if @model.get('reference_smiles_error')
        @renderSimilarityMapError()
      else
        console.log 'AAA image ready!'

    showPreloader: ->

      if not $(@el).attr('data-preloader-added') != 'yes'
        $newPreloader = $(glados.Utils.getContentFromTemplate('Handlebars-Common-MiniRepCardPreloader'))
        $(@el).append($newPreloader)
        $(@el).attr('data-preloader-added', 'yes')

      $newPreloader.show()
      $image = $(@el).find('img')
      $image.hide()

    renderSimilarityMapError: ->

      jqXHR = @model.get('reference_smiles_error_jqxhr')
      $errorMessagesContainer = $(@el).find('.BCK-error-message-container')
      if $errorMessagesContainer.length == 0
        errorMessagesContainer = '<div class="BCK-error-message-container"></div>'
        $(@el).append(errorMessagesContainer)
        $errorMessagesContainer = $(@el).find('.BCK-error-message-container')

      $errorMessagesContainer.html glados.Utils.ErrorMessages.getErrorImageContent(jqXHR)
      $image = $(@el).find('img')
      $image.hide()

