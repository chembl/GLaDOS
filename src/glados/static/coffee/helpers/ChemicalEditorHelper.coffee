glados.useNameSpace 'glados.helpers',
  ChemicalEditorHelper: class ChemicalEditorHelper

    @showChemicalEditorModal = (customContext, compound) ->

      editorModalID = 'modal-MarvinSketcher'
      $editorModal = $("#BCK-GeneratedModalsContainer #{editorModalID}")

      if $editorModal.length == 0

        $editorModal = ButtonsHelper.generateModalFromTemplate($trigger=undefined, 'Handlebars-Common-MarvinModal',
          startingTop=undefined, endingTop=undefined, customID=editorModalID)

      if not @marvinEditor?
        @marvinEditor = new MarvinSketcherView
          el: $editorModal

      @marvinEditor.clearStructure()

      if compound?
        thisContext = @
        compound.get('get_sdf_content_promise')().done (molfileData) ->
          thisContext.marvinEditor.loadStructure(molfileData, MarvinSketcherView.SDF_FORMAT)


      $editorModal.modal('open')

