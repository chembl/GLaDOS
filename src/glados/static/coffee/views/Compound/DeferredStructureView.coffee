glados.useNameSpace 'glados.views.Compound',
  DeferredStructureView: Backbone.View.extend
    initialize: ->

      @model.on glados.Events.Compound.SIMILARITY_MAP_READY, @renderSimilarityMap, @
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
        $preloader = $(@el).find('.BCK-preloader')
        $errorMessagesContainer = $(@el).find('.BCK-error-message-container')
        $image = $(@el).find('img.BCK-main-image')
        $simMapImage = $(@el).find('img.BCK-simMap-image')

        if $simMapImage.length == 0
          newImage = '<img class="BCK-simMap-image">'
          $(@el).append(newImage)
          $simMapImage = $(@el).find('img.BCK-simMap-image')

        $simMapImage.attr('src', 'data:image/png;base64,' + @model.get('similarity_map_base64_img'))
#        console.log 'AAA base64 img: ', @model.get('similarity_map_base64_img')

        $preloader.hide()
        $errorMessagesContainer.hide()
        $errorMessagesContainer.hide()
        $image.hide()
        $simMapImage.show()
        console.log 'AAA image set!!'

    showPreloader: ->

      if not $(@el).attr('data-preloader-added') != 'yes'
        $newPreloader = $(glados.Utils.getContentFromTemplate('Handlebars-Common-MiniRepCardPreloader'))
        $(@el).append($newPreloader)
        $(@el).attr('data-preloader-added', 'yes')

      $newPreloader.show()
      $image = $(@el).find('img.BCK-main-image')
      $image.hide()
      $simMapImage = $(@el).find('img.BCK-simMap-image')
      $simMapImage.hide()

    renderSimilarityMapError: ->

      jqXHR = @model.get('reference_smiles_error_jqxhr')
      $errorMessagesContainer = $(@el).find('.BCK-error-message-container')
      if $errorMessagesContainer.length == 0
        errorMessagesContainer = '<div class="BCK-error-message-container"></div>'
        $(@el).append(errorMessagesContainer)
        $errorMessagesContainer = $(@el).find('.BCK-error-message-container')

      $errorMessagesContainer.html glados.Utils.ErrorMessages.getErrorImageContent(jqXHR)
      $image = $(@el).find('img.BCK-main-image')
      $image.hide()
      $simMapImage = $(@el).find('img.BCK-simMap-image')
      $simMapImage.hide()

