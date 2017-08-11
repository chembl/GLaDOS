glados.useNameSpace 'glados.views.PaginatedViews',
  CompoundCardView: Backbone.View.extend

    events:
      'click .BCK-open-details': 'openDetails'
      'click .BCK-close-details': 'closeDetails'

    initialize: ->
      @MODEL_FETCHED = false
      @initDetailsSection()

    openDetails: ->

      if not @MODEL_FETCHED
        @model.fetch()
        @MODEL_FETCHED = true

      $detailsElement = $(@el).find('.BCK-details-container')
      $detailsElement.slideDown('fast')
      console.log 'OPEN DETAILS!'

    closeDetails: ->
      $detailsElement = $(@el).find('.BCK-details-container')
      $detailsElement.slideUp('fast')

    initDetailsSection: ->

      $preloaderContainer = $(@el).find('.BCK-Preloader-Container')
      glados.Utils.fillContentForElement($preloaderContainer)

    fillDetailsSection: ->

      $detailsContainer = $(@el).find('.BCK-details-container')
#      glados.Utils.$detailsContainer.
