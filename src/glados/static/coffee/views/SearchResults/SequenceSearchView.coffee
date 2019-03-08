glados.useNameSpace 'glados.views.SearchResults',
  SequenceSearchView: Backbone.View.extend

    EXAMPLE_SEQUENCE: '>sp|P35858|ALS_HUMAN Insulin-like growth factor-binding protein complex acid labile subunit OS=Homo sapiens GN=IGFALS PE=1 SV=1 \n' +
      'MALRKGGLALALLLLSWVALGPRSLEGADPGTPGEAEGPACPAACVCSYDDDADELSVFC\n' +
      'SSRNLTRLPDGVPGGTQALWLDGNNLSSVPPAAFQNLSSLGFLNLQGGQLGSLEPQALLG\n' +
      'LENLCHLHLERNQLRSLALGTFAHTPALASLGLSNNRLSRLEDGLFEGLGSLWDLNLGWN\n' +
      'SLAVLPDAAFRGLGSLRELVLAGNRLAYLQPALFSGLAELRELDLSRNALRAIKANVFVQ\n' +
      'LPRLQKLYLDRNLIAAVAPGAFLGLKALRWLDLSHNRVAGLLEDTFPGLLGLRVLRLSHN\n' +
      'AIASLRPRTFKDLHFLEELQLGHNRIRQLAERSFEGLGQLEVLTLDHNQLQEVKAGAFLG\n' +
      'LTNVAVMNLSGNCLRNLPEQVFRGLGKLHSLHLEGSCLGRIRPHTFTGLSGLRRLFLKDN\n' +
      'GLVGIEEQSLWGLAELLELDLTSNQLTHLPHRLFQGLGKLEYLLLSRNRLAELPADALGP\n' +
      'LQRAFWLDVSHNRLEALPNSLLAPLGRLRYLSLRNNSLRTFTPQPPGLERLWLEGNPWDC\n' +
      'GCPLKALRDFALQNPSAVPRFVQAICEGDDCQPPAYTYNNITCASPPEVVGLDLRDLSEA\n' +
      'HFAPC'

    events:
      'click .BCK-use-example-sequence': 'useExampleSequence'
      'click .BCK-clear-sequence': 'clearSequence'
      'click .BCK-upload-sequence': 'clickOnUploadSequenceInput'
      'change .BCK-upload-sequence-input': 'processFile'
      'input .BCK-sequence-textarea': 'resetFileInput'
      'input .BCK-sequence-textarea': 'toggleSearchButtonEnabling'
      'change .BCK-sequence-textarea': 'toggleSearchButtonEnabling'
      'input .BCK-search-param': 'updateParam'
      'change .BCK-search-param': 'updateParam'
      'click .BCK-trigger-search': 'triggerSearch'

    initialize: ->

      @paramsModel = new glados.models.Search.BLASTParamsModel()
      @searchParams = {}

    render: (queryParams) ->

      if @paramsModel.isNew()
        thisView = @

        @paramsModel.on 'change', ->

          blastParams = (param for param in thisView.paramsModel.get('params') when param.param_id != 'sequence')

          if queryParams?
            thisView.searchParams = queryParams
            previousSequence = queryParams.sequence
          else
            previousSequence = ''

          for param_obj in blastParams

            param_id = param_obj.param_id
            if queryParams?
              previousValue = queryParams[param_id]

            if not previousValue?

              if param_obj.allow_free_input
                param_obj.current_value = param_obj.default_value
              else
                for value_obj in param_obj.param_values
                  value_obj.is_selected = value_obj.is_default

            else

              if param_obj.allow_free_input
                param_obj.current_value = previousValue
              else
                for value_obj in param_obj.param_values
                  value_obj.is_selected = value_obj.value == previousValue

          templateParams =
            blast_params: blastParams
            previous_sequence: previousSequence

          thisView.blastParams = blastParams
          $element = $(thisView.el)
          glados.Utils.fillContentForElement($element, templateParams)
          thisView.initParamsToggler()
          $selectors = $element.find('.BCK-ParamSelect')
          $selectors.material_select()
          thisView.toggleSearchButtonEnabling()

        @paramsModel.fetch()

      @showModal()

    showModal: ->

      $element = $(@el)
      $element.modal('open')

    closeModal: ->

      $element = $(@el)
      $element.modal('close')

    initParamsToggler: ->

      $paramsToggler = $(@el).find('.BCK-show-parameters')
      $paramsContainer = $(@el).find('.BCK-params-container')
      $paramsContainer.attr('is_open', 'no')
      $paramsContainer.addClass('closed')

      thisView = @
      $paramsToggler.click ->

        if $paramsContainer.attr('is_open') == 'no'
          $paramsContainer.attr('is_open', 'yes')
          $paramsContainer.removeClass('closed')
          $paramsToggler.text('Hide Parameters')
        else
          $paramsContainer.attr('is_open', 'no')
          $paramsContainer.addClass('closed')
          $paramsToggler.text('Show Parameters')

#-----------------------------------------------------------------------------------------------------------------------
# Handling params
#-----------------------------------------------------------------------------------------------------------------------
    updateParam: (event) ->

      $paramElem = $(event.target)
      paramID = $paramElem.attr('data-param-id')
      value = $paramElem.val()
      @searchParams[paramID] = value

#-----------------------------------------------------------------------------------------------------------------------
# Helper buttons
#-----------------------------------------------------------------------------------------------------------------------
    useExampleSequence: ->

      $textArea = $(@el).find('.BCK-sequence-textarea')
      $textArea.val(@EXAMPLE_SEQUENCE)
      $textArea.trigger('change')
      @resetFileInput()

    clearSequence: ->

      $textArea = $(@el).find('.BCK-sequence-textarea')
      $textArea.val('')
      $textArea.trigger('change')
      @resetFileInput()

    clickOnUploadSequenceInput: ->

      $uploadSequenceInput = $(@el).find('.BCK-upload-sequence-input')
      $uploadSequenceInput.click()

    resetFileInput: ->

      $fileInput = $(@el).find('.BCK-upload-sequence-input')
      $fileInput.val('')

    processFile: (event) ->

      input = event.target
      reader = new FileReader()

      thisView = @
      reader.onload = ->
        text = reader.result
        $textArea = $(thisView.el).find('.BCK-sequence-textarea')
        $textArea.val(text)
        $textArea.trigger('change')

      reader.onerror = ->
        alert('There was an error while loading the file. Please try again.')

      reader.readAsText(input.files[0])

#-----------------------------------------------------------------------------------------------------------------------
# Trigger Search
#-----------------------------------------------------------------------------------------------------------------------
    toggleSearchButtonEnabling: ->

      $searchBtn = $(@el).find('.BCK-trigger-search')
      $textArea = $(@el).find('.BCK-sequence-textarea')
      currentText = $textArea.val()
      if currentText == ''
        $searchBtn.addClass('disabled')
      else
        $searchBtn.removeClass('disabled')

    triggerSearch: (event) ->

      $btn = $(event.target)
      if $btn.hasClass('disabled')
        return

      base64Params = btoa(JSON.stringify(@searchParams))
      url = glados.Settings.BLAST_SEARCH_RESULTS_PAGE + base64Params

      window.location.href = url
      @closeModal()