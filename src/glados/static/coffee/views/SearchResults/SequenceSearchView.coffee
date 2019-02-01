glados.useNameSpace 'glados.views.SearchResults',
  SequenceSearchView: Backbone.View.extend

    initialize: ->

      @state = glados.views.SearchResults.SequenceSearchView.states.INITIAL_STATE
      @selectorsActivated = false
      @paramsTogglerActivated = false

    render: ->

      if @state == glados.views.SearchResults.SequenceSearchView.states.INITIAL_STATE

        blastParameters = []
        for i in [1..12]
          blastParameters.push
            param_label: "Param#{i}"
            param_help_link: 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+(ProteinDatabases)-matrix'
            long: i == 11

        paramsObj =
          blast_params: blastParameters

        loadPromise = glados.Utils.fillContentForElement($(@el), paramsObj)
        thisView = @
        loadPromise.then ->
          console.log 'content loaded'
          @state = glados.views.SearchResults.SequenceSearchView.states.CONTENT_LOADED
          thisView.showModal()

        @state = glados.views.SearchResults.SequenceSearchView.states.LOADING_CONTENT

      else

        @showModal()

    showModal: ->

      console.log 'show modal'
      $element = $(@el)
      $selectors = $element.find('.BCK-ParamSelect')
      $element.modal('open')

      if not @selectorsActivated
        $selectors.material_select()
        console.log 'selectors activated'
        @selectorsActivated = true

      if not @paramsTogglerActivated

        @initParamsToggler()
        @paramsTogglerActivated = true

    initParamsToggler: ->

      $paramsToggler = $(@el).find('.BCK-show-parameters')
      $paramsContainer = $(@el).find('.BCK-params-container')
      $paramsContainer.attr('is_open', 'no')
      $paramsContainer.addClass('closed')

      $paramsToggler.click ->

        if $paramsContainer.attr('is_open') == 'no'
          console.log 'open params'
          $paramsContainer.attr('is_open', 'yes')
          $paramsContainer.removeClass('closed')
          $paramsToggler.text('Hide Parameters')
        else
          console.log 'close params'
          $paramsContainer.attr('is_open', 'no')
          $paramsContainer.addClass('closed')
          $paramsToggler.text('Show Parameters')





glados.views.SearchResults.SequenceSearchView.states =
  INITIAL_STATE: 'INITIAL_STATE'
  LOADING_PARAMS: 'LOADING_PARAMS'
  LOADING_CONTENT: 'LOADING_CONTENT'
  CONTENT_LOADED: 'CONTENT_LOADED'