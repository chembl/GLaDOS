glados.useNameSpace 'glados.views.PaginatedViews',
  ItemCardView: Backbone.View.extend

    events:
      'click .BCK-open-info': 'openInfo'
      'click .BCK-close-info': 'closeInfo'

    initialize: ->

      $detailsContainer = $(@el).find('.BCK-info-container')

      @MODEL_FETCHED = false

    openInfo: ->

      $detailsElement = $(@el).find('.BCK-info-container')
      console.log 'CHEMBL ID: ', @model.get('id')
      $tabsContentElement = $(@el).find('.BCK-tab-content')
      CompoundReportCardApp.initMiniCompoundReportCard($tabsContentElement, @model.get('id'))
      $detailsElement.slideDown('fast')
      console.log 'OPEN DETAILS!'

    closeInfo: ->
      $detailsElement = $(@el).find('.BCK-info-container')
      $detailsElement.slideUp('fast')


    renderDetails: ->

      $detailsContainer = $(@el).find('.BCK-info-container')

#      glados.Utils.$detailsContainer.
