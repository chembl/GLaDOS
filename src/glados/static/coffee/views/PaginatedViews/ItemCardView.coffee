glados.useNameSpace 'glados.views.PaginatedViews',
  ItemCardView: Backbone.View.extend

    TABS_CONTENT_TEMPLATE: 'Handlebars-Common-Paginated-Card-TabContent'
    WIDTH_THRESHOLD: 190

    events:
      'click .BCK-open-info': 'openInfo'
      'click .BCK-close-info': 'closeInfo'
      'click .BCK-openTab': 'openTab'

    initialize: ->

      cardWidth = $(@el).width()
      console.log 'CARD WIDTH: ', cardWidth
      if cardWidth < @WIDTH_THRESHOLD
        @hideInfoOpener()

    # ------------------------------------------------------------------------------------------------------------------
    # Info Footer
    # ------------------------------------------------------------------------------------------------------------------
    hideInfoOpener: ->

      $infoOpener = $(@el).find('.BCK-info-opener')
      $infoOpener.hide()

    openInfo: ->

      $infoElement = $(@el).find('.BCK-info-container')
      $infoElement.slideDown('fast')
      @showTab('Details')

    closeInfo: ->
      $infoElement = $(@el).find('.BCK-info-container')
      $infoElement.slideUp('fast')

    # ------------------------------------------------------------------------------------------------------------------
    # Tabs
    # ------------------------------------------------------------------------------------------------------------------
    openTab: (event) ->

      tabID = $(event.currentTarget).attr('data-tab-id')
      @showTab(tabID)

    showTab: (tabID) ->

      $tabsContentsElements = $(@el).find('.BCK-tabs-contents')
      $allTabContents = $tabsContentsElements.find('.BCK-tab-content')
      $allTabContents.hide()

      $tabContentElement = $tabsContentsElements.find('.BCK-tab-content[data-tab-id=' + tabID + ']')

      if $tabContentElement.length == 0
        $tabContentElement = $('div')
        content = glados.Utils.getContentFromTemplate @TABS_CONTENT_TEMPLATE,
          tab_id: tabID

        $tabsContentsElements.append(content)
        $tabContentElement = $tabsContentsElements.find('.BCK-tab-content[data-tab-id=' + tabID + ']')

      if $tabContentElement.attr('data-initialised') != 'yes'
        @initTab($tabContentElement, tabID)

      $tabContentElement.show()

      $allTabsSelectors = $(@el).find('.BCK-openTab')
      $allTabsSelectors.removeClass('selected')

      $currentTabSelector = $(@el).find('.BCK-openTab[data-tab-id=' + tabID + ']')
      $currentTabSelector.addClass('selected')

    initTab: ($tabElement, tabID) ->

      if tabID == 'Details'
        CompoundReportCardApp.initMiniCompoundReportCard($tabElement, undefined, @model,
          'Handlebars-Common-CompoundDetails')

      $tabElement.attr('data-initialised','yes')

    # ------------------------------------------------------------------------------------------------------------------
    # Mini report card on hover
    # ------------------------------------------------------------------------------------------------------------------


