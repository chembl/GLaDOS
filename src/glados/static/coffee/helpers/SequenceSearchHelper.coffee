glados.useNameSpace 'glados.helpers',
  SequenceSearchHelper: class SequenceSearchHelper

    @showSequenceSearchModal = ->

      modalID = 'modal-EnterASequence'
      $modal = $("#BCK-GeneratedModalsContainer ##{modalID}")

      if $modal.length == 0

        console.log 'creating modal'
        $modal = ButtonsHelper.generateModalFromTemplate($trigger=undefined, 'Handlebars-Common-StructureSearch',
          startingTop=undefined, endingTop=undefined, customID=modalID)

      if not @sequenceSearchView?

        @sequenceSearchView = new glados.views.SearchResults.SequenceSearchView
          el: $modal

      console.log '@showSequenceSearchModal: '
      $modal.modal('open')