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
      'input .BCK-search-param': 'updateParam'
      'change .BCK-search-param': 'updateParam'

    initialize: ->

      @selectorsActivated = false
      @paramsTogglerActivated = false
      @paramsModel = new glados.models.Search.BLASTParamsModel()
      @searchParams = {}

    render: ->

      if @paramsModel.isNew()
        console.log 'loading params'
        thisView = @
        @paramsModel.on 'change', ->

          blastParams = [param for param in thisView.paramsModel.get('params') when param.param_id != 'sequence']

          console.log 'blastParams: ', blastParams

          glados.Utils.fillContentForElement($(thisView.el))
          thisView.initParamsToggler()

        @paramsModel.fetch()

      @showModal()

    showModal: ->

      $element = $(@el)
      $selectors = $element.find('.BCK-ParamSelect')
      $element.modal('open')

      if not @selectorsActivated
        $selectors.material_select()
        @selectorsActivated = true

      if not @paramsTogglerActivated

        @initParamsToggler()
        @paramsTogglerActivated = true

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
      value =
      console.log 'param updated: ', paramID
      console.log 'value: ', $paramElem.val()
#      @searchParams[paramID]

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


glados.views.SearchResults.SequenceSearchView.states =
  INITIAL_STATE: 'INITIAL_STATE'
  LOADING_PARAMS: 'LOADING_PARAMS'
  LOADING_CONTENT: 'LOADING_CONTENT'
  CONTENT_LOADED: 'CONTENT_LOADED'