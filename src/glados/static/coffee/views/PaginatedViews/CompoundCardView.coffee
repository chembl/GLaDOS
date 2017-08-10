glados.useNameSpace 'glados.views.PaginatedViews',
  CompoundCardView: Backbone.View.extend

    events:
      'click .BCK-open-details': 'openDetails'
      'click .BCK-close-details': 'closeDetails'

    initialize: ->
      console.log 'INITIALIZING COMPOUND CARD VIEW!'

    openDetails: ->
      $detailsElement = $(@el).find('.BCK-details-container')
      $detailsElement.slideDown('fast')
      console.log 'OPEN DETAILS!'

    closeDetails: ->
      $detailsElement = $(@el).find('.BCK-details-container')
      $detailsElement.slideUp('fast')