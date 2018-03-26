glados.useNameSpace 'glados.views.PaginatedViews',
  CardZoomFunctions:

    POSSIBLE_CARD_SIZES_STRUCT:
      1:
        previous: 1
        next: 2
      2:
        previous: 1
        next: 3
      3:
        previous: 2
        next: 4
      4:
        previous: 3
        next: 6
      6:
        previous: 4
        next: 12
      12:
        previous: 6
        next: 12

    getPreviousSize: (currentSize) -> @POSSIBLE_CARD_SIZES_STRUCT[currentSize].previous
    getNextSize: (currentSize) -> @POSSIBLE_CARD_SIZES_STRUCT[currentSize].next

    DEFAULT_CARDS_SIZES:
      small: 12
      medium: 6
      large: 3

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

      pageSizeMustBe = @getPageSizeAccordingToZoom()
      @finishZoom(pageSizeMustBe)

    zoomOut: ->

      isDisabled = @$zoomControlsContainer.find('.BCK-zoom-out').hasClass('disabled')
      if isDisabled
        return

      @CURRENT_CARD_SIZES =
        small: @getPreviousSize(@CURRENT_CARD_SIZES.small)
        medium: @getPreviousSize(@CURRENT_CARD_SIZES.medium)
        large: @getPreviousSize(@CURRENT_CARD_SIZES.large)

      pageSizeMustBe = @getPageSizeAccordingToZoom()
      @finishZoom(pageSizeMustBe)

    resetZoom: ->

      isDisabled = @$zoomControlsContainer.find('.BCK-reset-zoom').hasClass('disabled')
      if isDisabled
        return

      @CURRENT_CARD_SIZES =
        small: @DEFAULT_CARDS_SIZES.small
        medium: @DEFAULT_CARDS_SIZES.medium
        large: @DEFAULT_CARDS_SIZES.large

      pageSizeMustBe = @getPageSizeAccordingToZoom()
      @finishZoom(pageSizeMustBe)

    getPageSizeAccordingToZoom: ->

      currentScreenType = GlobalVariables.CURRENT_SCREEN_TYPE
      if currentScreenType == glados.Settings.SMALL_SCREEN
        return @CARD_SIZE_TO_PAGE_SIZE[@CURRENT_CARD_SIZES.small]
      else if currentScreenType == glados.Settings.MEDIUM_SCREEN
        return @CARD_SIZE_TO_PAGE_SIZE[@CURRENT_CARD_SIZES.medium]
      else
        return @CARD_SIZE_TO_PAGE_SIZE[@CURRENT_CARD_SIZES.large]


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

    isCardsZoomEnabled: -> @config.enable_cards_zoom == true