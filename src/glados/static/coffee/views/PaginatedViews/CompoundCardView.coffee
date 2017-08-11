glados.useNameSpace 'glados.views.PaginatedViews',
  CompoundCardView: Backbone.View.extend

    events:
      'click .BCK-open-details': 'openDetails'
      'click .BCK-close-details': 'closeDetails'

    initialize: ->
      @model.on 'change', @renderDetails, @

      @MODEL_FETCHED = false
      @initDetailsSection()

    openDetails: ->

      if not @MODEL_FETCHED
        console.log 'GOING TO FETCH MODEL!'
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

    renderDetails: ->

      $detailsContainer = $(@el).find('.BCK-details-container')

#      glados.Utils.$detailsContainer.
