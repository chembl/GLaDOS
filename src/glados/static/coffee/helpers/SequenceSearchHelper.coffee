glados.useNameSpace 'glados.helpers',
  SequenceSearchHelper: class SequenceSearchHelper

    @showSequenceSearchModal = (queryParams) ->

      modalID = 'modal-EnterASequence'
      $modal = $("#BCK-GeneratedModalsContainer ##{modalID}")

      if $modal.length == 0

        $modal = ButtonsHelper.generateModalFromTemplate($trigger=undefined, 'Handlebars-Common-SequenceSearch',
          startingTop=undefined, endingTop=undefined, customID=modalID)

      if not @sequenceSearchView?

        @sequenceSearchView = new glados.views.SearchResults.SequenceSearchView
          el: $modal

      @sequenceSearchView.render(queryParams)