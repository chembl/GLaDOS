glados.useNameSpace 'glados.views.Compound',
  DeferredStructureView: Backbone.View.extend
    initialize: ->

      @model.on glados.Events.Compound.SIMILARITY_MAP_READY, @renderSimilarityMap, @
      @model.on glados.Events.Compound.SIMILARITY_MAP_ERROR, @renderLoadingError, @
      @model.on glados.Events.Compound.STRUCTURE_HIGHLIGHT_ERROR, @renderLoadingError, @
      @model.on 'change:show_similarity_map', @handleShowStatusChanged, @
      @renderSimilarityMap()

    renderSimilarityMap: ->

      if @model.get('loading_similarity_map')
       @showPreloader()
      else if @model.get('reference_smiles_error')
        @renderLoadingError()
      else
        $simMapImage = $(@el).find('img.BCK-simMap-image')

        if $simMapImage.length == 0
          newImage = '<img class="BCK-simMap-image similarity-map-img">'
          $(@el).append(newImage)
          $simMapImage = $(@el).find('img.BCK-simMap-image')

        $simMapImage.attr('src', 'data:image/png;base64,' + @model.get('similarity_map_base64_img'))

        @showCorrectImage()

    showPreloader: ->

      if  $(@el).attr('data-preloader-added') != 'yes'
        $newPreloader = $(glados.Utils.getContentFromTemplate('Handlebars-Common-MiniRepCardPreloader'))
        $(@el).append($newPreloader)
        $(@el).attr('data-preloader-added', 'yes')

      $preloader = $(@el).find('.BCK-preloader')
      $preloader.show()
      @hideAllImages()

    renderLoadingError: ->

      jqXHR = @model.get('reference_smiles_error_jqxhr')
      $errorMessagesContainer = $(@el).find('.BCK-error-message-container')
      if $errorMessagesContainer.length == 0
        errorMessagesContainer = '<div class="BCK-error-message-container"></div>'
        $(@el).append(errorMessagesContainer)
        $errorMessagesContainer = $(@el).find('.BCK-error-message-container')

      $errorMessagesContainer.html glados.Utils.ErrorMessages.getErrorImageContent(jqXHR)
      @hideAllImages()

    #-------------------------------------------------------------------------------------------------------------------
    # Images Handling
    #-------------------------------------------------------------------------------------------------------------------
    handleShowStatusChanged: ->

      if @model.get('loading_similarity_map') and @model.get('show_similarity_map')
        @showPreloader()
        return

      @showCorrectImage()

    hideAllImages: ->

      $image = $(@el).find('img.BCK-main-image')
      $image.hide()
      $simMapImage = $(@el).find('img.BCK-simMap-image')
      $simMapImage.hide()

    showCorrectImage: ->

      $preloader = $(@el).find('.BCK-preloader')
      $preloader.hide()

      $errorMessagesContainer = $(@el).find('.BCK-error-message-container')
      $errorMessagesContainer.hide()

      $image = $(@el).find('img.BCK-main-image')
      $simMapImage = $(@el).find('img.BCK-simMap-image')

      if @model.get('show_similarity_map')
        $simMapImage.show()
        $image.hide()
      else
        $simMapImage.hide()
        $image.show()

