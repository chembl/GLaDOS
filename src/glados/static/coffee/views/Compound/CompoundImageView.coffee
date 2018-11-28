# View that renders the Image of the compound for the Compound Name and Classification Section
CompoundImageView = CardView.extend(DownloadViewExt).extend

  RENDERER_3D_LITEMOL_NAME:  '3DLiteMol'
  RENDERER_3D_3DMOL_NAME:  '3D3DMol'
  RENDERER_3D_SPECK_NAME:  '3DSpeck'

  initialize: ->
    @model.on 'change', @.render, @


  render: ->

    if not @model.get('structure_image')
      $('#CNC-3d-modal-trigger').hide()
      $('#CNC-3d-modal-trigger-small').hide()
    else
      $(@el).find("a[href='#BCK-compound-3dview-3DMol']").attr('data-renderer', @RENDERER_3D_3DMOL_NAME)
      $(@el).find("a[href='#BCK-compound-3dview-LiteMol']").attr('data-renderer', @RENDERER_3D_LITEMOL_NAME)
      $(@el).find("a[href='#BCK-compound-3dview-Speck']").attr('data-renderer', @RENDERER_3D_SPECK_NAME)

    $('#CNC-3d-modal').modal
      ready: @initDefault3DView.bind @


    @renderImage()
    @initDownloadButtons()
    @initZoomModal()

  events: ->
    return _.extend {}, DownloadViewExt.events,
      "click a[href='#BCK-compound-3dview-3DMol']": "lazyInit3DView"
      "click a[href='#BCK-compound-3dview-LiteMol']": "lazyInit3DView"
      "click a[href='#BCK-compound-3dview-Speck']": "lazyInit3DView"
      'click .CNC-img': 'openEditor'

  openEditor: ->

    @molecule_structures = @model.get('molecule_structures')
    if not @molecule_structures?
      return

    glados.helpers.ChemicalEditorHelper.showChemicalEditorModal(undefined, @model)

  renderImage: ->
    img_url = @model.get('image_url')

    img = $(@el).find('#Bck-COMP_IMG')
    img.load $.proxy(@showCardContent, @)

    # protein_structure is used when the molecule has a very complex structure that can not be shown in an image.
    # not_available is when the compound has no structure to show.
    # not_found is when there was an error loading the image
    img.error ->
      img.attr('src', glados.Settings.STATIC_URL+'img/structure_not_found.png')

    img.attr('src', img_url)


  initDownloadButtons: ->
    $dwn_png = $('.CNC-download-png')
    $dwn_svg = $('.CNC-download-svg')
    if @model.get('structure_image')
      $dwn_png.attr('href', @model.get('image_url_png'))
      $dwn_png.attr('download', @model.get('molecule_chembl_id') + '.png')

      $dwn_svg.attr('href', @model.get('image_url'))
      $dwn_svg.attr('download', @model.get('molecule_chembl_id') + '.svg')
    else
      disable_func = (e) -> e.preventDefault()
      $dwn_png.click(disable_func)
      $dwn_png.attr('class', 'CNC-download-png disabled')
      $dwn_svg.click(disable_func)
      $dwn_svg.attr('class', 'CNC-download-svg disabled')

  initZoomModal: ->

    # If the image strcuture can't be shown, don't activate the zoom modal.
    img = $(@el).find('#Bck-COMP_IMG')
    if img.attr('src').indexOf(glados.Settings.STATIC_URL+'') > -1 or img.attr('src').indexOf(glados.Settings.OLD_DEFAULT_IMAGES_BASE_URL) > -1
      $('#CNC-IMG-Options-Zoom, #CNC-IMG-Options-Zoom-small').remove()
      return

    modal = $(@el).find('#CNC-zoom-modal')

    title = modal.find('h3')
    title.text(@model.get('molecule_chembl_id'))

    img = modal.find('#Bck-Comp-Img-zoom')

    img.load ->

      $('#Bck-Comp-Img-zoom-preloader').hide()
      $(@).show()

    img.attr('src', glados.Settings.WS_BASE_URL + 'image/' + @model.get('molecule_chembl_id') + @getParamsFromSwitches())
    img.attr('alt', 'Structure of ' + @model.get('molecule_chembl_id'))

    $(@el).find('#Bck-Renderer-Switch, #Bck-Format-Switch, #Bck-Coordinates-Switch').click @handleImgSwitch(@)

    $('#Bck-Comp-Img-zoom-menuclose').click ->
      $('#Bck-Comp-Img-zoom-menu').slideUp ->
       $('#Bck-Comp-Img-zoom-menuopen').show()

    $('#Bck-Comp-Img-zoom-menuopen').click ->
      $('#Bck-Comp-Img-zoom-menu').slideDown()
      $(@).hide()

  handleImgSwitch: (parentView) ->
    return ->
      img = $(parentView.el).find('#Bck-Comp-Img-zoom')
      $('#Bck-Comp-Img-zoom-preloader').show()
      img.hide()
      img.attr('src', glados.Settings.WS_BASE_URL + 'image/' + parentView.model.get('molecule_chembl_id') + parentView.getParamsFromSwitches())



  getParamsFromSwitches: ->
    renderer = 'engine=' + if $('#Bck-Renderer-Switch').prop('checked') then 'indigo' else 'rdkit'
    format = 'format=' + if $('#Bck-Format-Switch').prop('checked') then 'png' else 'svg'
    coords = if $('#Bck-Coordinates-Switch').prop('checked') then 'ignoreCoords=1' else ''

    return '?' + renderer + '&' + format + '&' + coords

  initDefault3DView: ->

    #make sure the speck visualisation is selected, this triggers lazyInit3DView
    $('ul.tabs').tabs('select_tab', 'BCK-compound-3dview-3DMol')


  lazyInit3DView: (e) ->

    requiredRenderer = $(e.currentTarget).attr('data-renderer')
    view = @get3DView requiredRenderer
    # I can assume that the model has already been fetched, because the button that opens the modal has been rendered.
    # the button is only rendered after the model has been fetched.
    # this view doesn't render on change, if the user never opens the visualisation it never loads unnecessarily the 3D
    # coordinates
    view.render()


  renderers3D: {}
  # gets a 3D view depending on the renderer name, it makes sure that this parent view has only one instance of that
  # 3d view
  # rendererName is defined in GlobalVariables
  get3DView: (rendererName) ->
    # initializes the 3d sdf data if it has not been initialized yet
    if not @model.get('current3DData')?
      @model.calculate3DSDFAndXYZ(0)
    if not @renderer3DOptionsView?
      @renderer3DOptionsView = new glados.views.Compound.Compound3DMethodSelectorView
        el: $('#Bck-Comp-3D-options-menu')
        model: @model
    # TODO: destroy WebGL Context that are not active
    # initialise if not already
    if !@renderers3D[rendererName]?

      switch rendererName

        when @RENDERER_3D_3DMOL_NAME

          @renderers3D[rendererName] = new Compound3DView3DMol
            el: $('#BCK-compound-3dview-3DMol')
            model: @model

        when @RENDERER_3D_LITEMOL_NAME

          @renderers3D[rendererName] = new Compound3DViewLiteMol
            el: $('#BCK-compound-3dview-LiteMol')
            model: @model

        when @RENDERER_3D_SPECK_NAME

          @renderers3D[rendererName] = new Compound3DViewSpeck
            el: $('#BCK-compound-3dview-Speck')
            model: @model
            type: 'reduced'

    return @renderers3D[rendererName]

  # --------------------------------------------------------------------
  # Downloads
  # --------------------------------------------------------------------

  getFilename: (format) ->

    if format == 'csv'
      return @model.get('molecule_chembl_id') + 'NameAndClassification.csv'
    else if format == 'json'
      return @model.get('molecule_chembl_id') + 'NameAndClassification.json'
    else if format == 'xlsx'
      return @model.get('molecule_chembl_id') + 'NameAndClassification.xlsx'
    else
      return 'file.txt'




