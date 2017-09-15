glados.useNameSpace 'glados.views.PaginatedViews',
  CardZoomFunctions:

    fillZoomContainer: ->

      $zoomBtnsContainer = @$zoomControlsContainer
      glados.Utils.fillContentForElement $zoomBtnsContainer,
        disable_zoom_in: @mustDisableZoomIn()
        disable_reset: @mustDisableReset()
        disable_zoom_out: @mustDisableZoomOut()

    zoomIn: ->

      isDisabled = @$zoomControlsContainer.find('.BCK-zoom-in').hasClass('disabled')
      if isDisabled
        return

      @CURRENT_CARD_SIZES =
        small: @getNextSize(@CURRENT_CARD_SIZES.small)
        medium: @getNextSize(@CURRENT_CARD_SIZES.medium)
        large: @getNextSize(@CURRENT_CARD_SIZES.large)

      if @isInfinite()
        @collection.setPage(1)
      else
        @render()

      @render()

    zoomOut: ->

      isDisabled = @$zoomControlsContainer.find('.BCK-zoom-out').hasClass('disabled')
      if isDisabled
        return

      @CURRENT_CARD_SIZES =
        small: @getPreviousSize(@CURRENT_CARD_SIZES.small)
        medium: @getPreviousSize(@CURRENT_CARD_SIZES.medium)
        large: @getPreviousSize(@CURRENT_CARD_SIZES.large)

      if @isInfinite()
        @collection.setPage(1)
      else
        @render()

    resetZoom: ->

      isDisabled = @$zoomControlsContainer.find('.BCK-reset-zoom').hasClass('disabled')
      if isDisabled
        return

      @CURRENT_CARD_SIZES =
        small: @DEFAULT_CARDS_SIZES.small
        medium: @DEFAULT_CARDS_SIZES.medium
        large: @DEFAULT_CARDS_SIZES.large

      if @isInfinite()
        @collection.setPage(1)
      else
        @render()

      @render()


    mustDisableZoomIn: ->
      currentScreenType = GlobalVariables.CURRENT_SCREEN_TYPE
      if currentScreenType == glados.Settings.SMALL_SCREEN
        return @getNextSize(@CURRENT_CARD_SIZES.small) == @CURRENT_CARD_SIZES.small
      else if currentScreenType == glados.Settings.MEDIUM_SCREEN
        return @getNextSize(@CURRENT_CARD_SIZES.medium) == @CURRENT_CARD_SIZES.medium
      else
        return @getNextSize(@CURRENT_CARD_SIZES.large) == @CURRENT_CARD_SIZES.large

    mustDisableReset: ->
      currentScreenType = GlobalVariables.CURRENT_SCREEN_TYPE
      if currentScreenType == glados.Settings.SMALL_SCREEN
        return @DEFAULT_CARDS_SIZES.small == @CURRENT_CARD_SIZES.small
      else if currentScreenType == glados.Settings.MEDIUM_SCREEN
        return @DEFAULT_CARDS_SIZES.medium == @CURRENT_CARD_SIZES.medium
      else
        return @DEFAULT_CARDS_SIZES.large == @CURRENT_CARD_SIZES.large

    mustDisableZoomOut: ->
      currentScreenType = GlobalVariables.CURRENT_SCREEN_TYPE
      if currentScreenType == glados.Settings.SMALL_SCREEN
        return @getPreviousSize(@CURRENT_CARD_SIZES.small) == @CURRENT_CARD_SIZES.small
      else if currentScreenType == glados.Settings.MEDIUM_SCREEN
        return @getPreviousSize(@CURRENT_CARD_SIZES.medium) == @CURRENT_CARD_SIZES.medium
      else
        return @getPreviousSize(@CURRENT_CARD_SIZES.large) == @CURRENT_CARD_SIZES.large

    isCardsZoomEnabled: -> @collection.getMeta('enable_cards_zoom')