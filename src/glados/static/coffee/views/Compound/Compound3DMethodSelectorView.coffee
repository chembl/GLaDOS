glados.useNameSpace 'glados.views.Compound',
  # View that renders the method selector for the 3D sdf
  Compound3DMethodSelectorView: Backbone.View.extend

    initialize: ()->
      @model.on 'change:cur3DEndpointIndex', @render, @
      @hbTemplate = Handlebars.compile($('#Handlebars-Compound-3D-options-menu').html())
      @render()

    render: ()->
      data = {
        renderingOptions: []
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

