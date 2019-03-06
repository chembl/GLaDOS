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

    initialize: ->

      @state = glados.views.SearchResults.SequenceSearchView.states.INITIAL_STATE
      @selectorsActivated = false
      @paramsTogglerActivated = false

    render: ->

      if @state == glados.views.SearchResults.SequenceSearchView.states.INITIAL_STATE

#        blastParameters = []
#        for i in [1..12]
#          blastParameters.push
#            param_label: "Param#{i}"
#            param_help_link: 'https://www.ebi.ac.uk/seqdb/confluence/pages/viewpage.action?pageId=68167377#NCBIBLAST+(ProteinDatabases)-matrix'
#            long: i == 11
#
#        paramsObj =
#          blast_params: blastParameters


        loadPromise = glados.Utils.fillContentForElement($(@el))
        thisView = @
        loadPromise.then ->
          @state = glados.views.SearchResults.SequenceSearchView.states.CONTENT_LOADED
          thisView.showModal()

        @state = glados.views.SearchResults.SequenceSearchView.states.LOADING_CONTENT

      else

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
          thisView.loadParams()
        else
          $paramsContainer.attr('is_open', 'no')
          $paramsContainer.addClass('closed')
          $paramsToggler.text('Show Parameters')

    loadParams: ->

      console.log 'loadParams'
      if not @paramsModel?
        @paramsModel = new glados.models.Search.BLASTParamsModel()

      if not @paramsModel.paramsLoaded()

        @paramsModel.fetch()

        thisView = @
        @paramsModel.on 'error', ->
          $paramsContainer = $(thisView.el).find('.BCK-params-container')
          $paramsContainer.text('There was an error while loading the parameters. Please try again later.')


      console.log '@paramsModel: ', @paramsModel



    useExampleSequence: ->

      $textArea = $(@el).find('.BCK-sequence-textarea')
      $textArea.val(@EXAMPLE_SEQUENCE)
      @resetFileInput()

    clearSequence: ->

      $textArea = $(@el).find('.BCK-sequence-textarea')
      $textArea.val('')
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

      reader.onerror = ->
        alert('There was an error while loading the file. Please try again.')


      reader.readAsText(input.files[0])


glados.views.SearchResults.SequenceSearchView.states =
  INITIAL_STATE: 'INITIAL_STATE'
  LOADING_PARAMS: 'LOADING_PARAMS'
  LOADING_CONTENT: 'LOADING_CONTENT'
  CONTENT_LOADED: 'CONTENT_LOADED'