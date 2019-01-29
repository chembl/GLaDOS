glados.useNameSpace 'glados.helpers',
  SequenceSearchHelper: class SequenceSearchHelper

    @showSequenceSearchModal = ->

      modalID = 'modal-EnterASequence'
      $modal = $("#BCK-GeneratedModalsContainer ##{modalID}")

      console.log '@showSequenceSearchModal: '

      if $modal.length == 0

        console.log 'creating modal'
        $modal = ButtonsHelper.generateModalFromTemplate($trigger=undefined, 'Handlebars-Common-StructureSearch',
          startingTop=undefined, endingTop=undefined, customID=modalID)

      $modal.modal('open')