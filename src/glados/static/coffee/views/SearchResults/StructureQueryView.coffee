glados.useNameSpace 'glados.views.SearchResults',
  StructureQueryView: Backbone.View.extend

    events:
      'click .BCK-Edit-Query': 'showEditModal'

    initialize: ->

      @queryParams = @model.get('query_params')
      @model.on 'change:state', @render, @

      if @queryParams.search_term.startsWith('CHEMBL')
        @img_url = glados.Settings.WS_BASE_URL + 'image/' + @queryParams.search_term + '.svg?engine=indigo'
        @render()
      else
        @render()
        @getSmilesImageAndRender()

    getCtabSvgAndRender: ()->
      if @ctabData?
        formData = new FormData()
        molFileBlob = new Blob([@ctabData], {type: 'chemical/x-mdl-molfile'})
        formData.append('file', molFileBlob, 'molecule.mol')
        formData.append('computeCoords', 0)
        formData.append('sanitize', 0)

        ajaxRequestDict =
          url: glados.Settings.BEAKER_BASE_URL + 'ctab2svg'
          data: formData
          enctype: 'multipart/form-data'
          processData: false
          contentType: false
          cache: false
          converters:
            'text xml': String

        deferred = $.post ajaxRequestDict
        deferred.done ((svgData)->
          @img_url = 'data:image/svg+xml;base64,'+btoa(svgData)
        ).bind(@)

        deferred.then @render.bind(@)
        return deferred

    getSmilesImageAndRender: ->
      formData = new FormData()
      smilesFileBlob = new Blob([@queryParams.search_term], {type: 'chemical/x-daylight-smiles'})
      formData.append('file', smilesFileBlob, 'molecule.smi')
      formData.append('sanitize', 0)

      ajaxRequestDict =
        url: glados.Settings.BEAKER_BASE_URL + 'smiles2ctab'
        data: formData
        enctype: 'multipart/form-data'
        processData: false
        contentType: false
        cache: false

      deferred = $.post(ajaxRequestDict)
      deferred.done ((ctabData)->
        @ctabData = ctabData
        @img_url = glados.Settings.BEAKER_BASE_URL + 'ctab2svg/'+ btoa(ctabData)
      ).bind(@)

      deferred.then @getCtabSvgAndRender.bind(@)
      return deferred

    render: ->

      img_url = @img_url
      img_url ?= glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/unknown.svg'

      glados.Utils.fillContentForElement $(@el),
        image_url: img_url
        search_term: @queryParams.search_term
        similarity: @queryParams.threshold
        status_text: @getStatusText()

    getStatusText: ->

      currentStatus = @model.get('state')
      if currentStatus == glados.models.Search.StructureSearchModel.STATES.INITIAL_STATE
        return 'Submitting'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.ERROR_STATE
        return 'There was an error. Please try again later.'
      else if currentStatus == glados.models.Search.StructureSearchModel.STATES.SEARCH_QUEUED
        return 'Submitted'

    showEditModal: (event) ->
      @$clickedElem = $(event.currentTarget)
      if not @$modal?
        @$modal = ButtonsHelper.generateModalFromTemplate(@$clickedElem, 'Handlebars-Common-MarvinModal')
        sketcherParams =
          el: @$modal
          custom_initial_similarity: @queryParams.threshold

        if @queryParams.search_term.startsWith('CHEMBL')
          sketcherParams.chembl_id_to_load_on_ready = @queryParams.search_term
        else
          sketcherParams.smiles_to_load_on_ready = @queryParams.search_term

        new MarvinSketcherView(sketcherParams)