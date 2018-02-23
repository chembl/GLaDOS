glados.useNameSpace 'glados.helpers',
  ChemicalEditorHelper: class ChemicalEditorHelper

    @showChemicalEditorModal = ->

      editorModalID = 'modal-MarvinSketcher'
      $editorModal = $("#BCK-GeneratedModalsContainer #{editorModalID}")

      if $editorModal.length == 0

        $editorModal = ButtonsHelper.generateModalFromTemplate($trigger=undefined, 'Handlebars-Common-MarvinModal',
          startingTop=undefined, endingTop=undefined, customID=editorModalID)

      @marvinEditor = new MarvinSketcherView
        el: $editorModal

      $editorModal.modal('open')

