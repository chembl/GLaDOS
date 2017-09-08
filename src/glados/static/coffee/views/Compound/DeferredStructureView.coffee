glados.useNameSpace 'glados.views.Compound',
  DeferredStructureView: Backbone.View.extend
    initialize: ->

      @initPreloader()
      @initErrorMessagesContainer()
      @$image = $(@el).find('img.BCK-main-image')
      @$simMapImage = $(@el).find('img.BCK-specialStruct-image')

      console.log 'init DeferredStructureView: ', arguments
      if @model.get('enable_similarity_map')
        @model.on glados.Events.Compound.SIMILARITY_MAP_READY, @showCorrectImage, @
        @model.on glados.Events.Compound.SIMILARITY_MAP_ERROR, @showCorrectImage, @
        @model.on 'change:show_similarity_map', @showCorrectImage, @

      @showCorrectImage()

    #-------------------------------------------------------------------------------------------------------------------
    # Structure show
    #-------------------------------------------------------------------------------------------------------------------
    renderSimilarityMap: ->
      @$simMapImage.attr('src', 'data:image/png;base64,' + @model.get('similarity_map_base64_img'))

    #-------------------------------------------------------------------------------------------------------------------
    # General
    #-------------------------------------------------------------------------------------------------------------------
    initPreloader: ->

      @$preloaderContainer = $(@el).find('.BCK-preloader')
      @$preloaderContainer.html glados.Utils.getContentFromTemplate('Handlebars-Common-MiniRepCardPreloader')
      @$preloaderContainer.hide()

    showPreloader: ->

      @$preloaderContainer.show()
      @hideAllImages()

    hidePreloader: -> @$preloaderContainer.hide()

    initErrorMessagesContainer: -> @$errorMessagesContainer = $(@el).find('.BCK-error-messages-container')

    renderLoadingError: ->

      jqXHR = @model.get('reference_smiles_error_jqxhr')
      @$errorMessagesContainer.html glados.Utils.ErrorMessages.getErrorImageContent(jqXHR)

    showLoadingError: ->

      @hidePreloader()
      @hideAllImages()
      @$errorMessagesContainer.show()

    hideErrorMessagesContainer: -> @$errorMessagesContainer.hide()
    #-------------------------------------------------------------------------------------------------------------------
    # Images Handling
    #-------------------------------------------------------------------------------------------------------------------
    hideAllImages: ->

      $image = $(@el).find('img.BCK-main-image')
      $image.hide()
      $simMapImage = $(@el).find('img.BCK-simMap-image')
      $simMapImage.hide()

    showCorrectImage: ->

      console.log 'show correct image!'


      if @model.get('show_similarity_map')

        console.log 'showing similarity map!'
        if @model.get('loading_similarity_map')
          console.log 'it is loading!'
          @showPreloader()
        else if @model.get('reference_smiles_error')
          console.log 'there is an error!'
          @renderLoadingError()
          @showLoadingError()
        else
          console.log 'show special structure image!!'
          @showSpecialStructureImage()

      else

        @showNormalImage()

    showNormalImage: ->

      @$simMapImage.hide()
      @$image.show()
      @hidePreloader()
      @hideErrorMessagesContainer()

    showSpecialStructureImage: ->

      @renderSimilarityMap()
      @$image.hide()
      @$simMapImage.show()
      @hidePreloader()
      @hideErrorMessagesContainer()

