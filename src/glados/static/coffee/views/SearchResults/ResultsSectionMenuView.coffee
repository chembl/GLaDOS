# this view is in charge of handling the menu bar that appears on top of the results
glados.useNameSpace 'glados.views.SearchResults',
  ResultsSectionMenuViewView: Backbone.View.extend

    events:
      'click .BCK-download-btn-for-format': 'triggerAllItemsDownload'
      'click .BCK-btn-switch-view': 'switchResultsView'

    initialize: ->
      @collection.on 'reset do-repaint sort', @render, @

    render: ->
      if @collection.getMeta('total_records') != 0

        $downloadBtnsContainer = $(@el).find('.BCK-download-btns-container')
        $downloadBtnsContainer.html Handlebars.compile($('#' + $downloadBtnsContainer.attr('data-hb-template')).html())
          formats: @collection.getMeta('download_formats')

        $changeViewBtnsContainer = $(@el).find('.BCK-changeView-btns-container')
        $changeViewBtnsContainer.html Handlebars.compile($('#' + $changeViewBtnsContainer.attr('data-hb-template')).html())
          options: ( {
            label: viewLabel,
            icon_class: glados.Settings.DEFAULT_RESULTS_VIEWS_ICONS[viewLabel]
          } for viewLabel in @collection.getMeta('available_views'))




#--------------------------------------------------------------------------------------
# Download Buttons
#--------------------------------------------------------------------------------------

    triggerAllItemsDownload: (event) ->
      desiredFormat = $(event.currentTarget).attr('data-format')
      $progressMessages = $(@el).find('.download-messages-container')
      @collection.downloadAllItems(desiredFormat, $progressMessages)

    switchResultsView: (event) ->
      desiredView = $(event.currentTarget).attr('data-view')
      console.log 'SWITCH TO VIEW: ', desiredView