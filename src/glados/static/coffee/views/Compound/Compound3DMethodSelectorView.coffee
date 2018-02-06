glados.useNameSpace 'glados.views.Compound',
  # View that renders the method selector for the 3D sdf
  Compound3DMethodSelectorView: Backbone.View.extend

    initialize: ()->
      @model.on 'change:cur3DEndpointIndex', @render, @
      @model.on 'change:current3DXYZData', @render, @
      @model.on 'change:current3DData', @render, @
      @hbTemplate = Handlebars.compile($('#Handlebars-Compound-3D-options-menu').html())
      @render()

    getDesiredFile: (sdfFile)->
      desiredFile = null
      if sdfFile and (@model.get 'current3DData')?
        desiredFile = @model.get 'current3DData'
      else if (@model.get 'current3DXYZData')?
        desiredFile = @model.get 'current3DXYZData'
      return desiredFile

    downloadFile: (sdfFile)->
      fileToDownload = @getDesiredFile(sdfFile)
      mimeType = if sdfFile then 'chemical/x-mdl-sdfile' else 'chemical/x-xyz'
      fileExtension = if sdfFile then '.sdf' else '.xyz'
      typeForceField = Compound.SDF_3D_ENDPOINTS[@model.get 'cur3DEndpointIndex'].label
      blobToDownload = new Blob([fileToDownload], {type: mimeType+";charset=utf-8"})
      saveAs(blobToDownload, @model.get('molecule_chembl_id')+'-'+typeForceField+fileExtension) unless glados.JS_TEST_MODE

    copyFile: (sdfFile)->
      fileToDownload = @getDesiredFile(sdfFile)
      copyElem = $(@el).find if sdfFile then '.sdf-3d-copy' else '.xyz-3d-copy'
      ButtonsHelper.handleCopyDynamic(copyElem, fileToDownload)

    render: ()->
      data = {
        renderingOptions: []
        enable_sdf: (@model.get 'current3DData')?
        enable_xyz: (@model.get 'current3DXYZData')?
      }
      selectedIdx = @model.get('cur3DEndpointIndex')
      for renderingOptionI, index in Compound.SDF_3D_ENDPOINTS
        data.renderingOptions.push {
          label: renderingOptionI.label
          selected: (index == selectedIdx)
        }
      rendererSelectionChange = (newIndex)->
        @model.calculate3DSDFAndXYZ(newIndex)
      rendererSelectionChange = rendererSelectionChange.bind(@)
      $(@el).find('.3D-options').html(@hbTemplate(data))
      $(@el).find('input[type=radio][name=renderer]').change () ->
        rendererSelectionChange(parseInt(@value))
      $('#Bck-Comp-3D-options-menuclose').click ->
        $('#Bck-Comp-3D-options-menu').slideUp ->
         $('#Bck-Comp-3D-options-menuopen').show()

      $('#Bck-Comp-3D-options-menuopen').click ->
        $('#Bck-Comp-3D-options-menu').slideDown()
        $(@).hide()

      if (@model.get 'current3DData')?
        ButtonsHelper.initLinkButton $(@el).find('.sdf-3d-dnld'), 'Download SDF File to clipboard',
          @downloadFile.bind(@, true)

        ButtonsHelper.initLinkButton $(@el).find('.sdf-3d-copy'), 'Copy SDF File to clipboard',
          @copyFile.bind(@, true)

      if (@model.get 'current3DXYZData')?
        ButtonsHelper.initLinkButton $(@el).find('.xyz-3d-dnld'), 'Download XYZ File to clipboard',
          @downloadFile.bind(@, false)

        ButtonsHelper.initLinkButton $(@el).find('.xyz-3d-copy'), 'Copy XYZ File to clipboard',
          @copyFile.bind(@, false)
