# View that renders the Image of the compound for the Compound Name and Classification Section
CompoundImageView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @

  render: ->
    @renderImage()
    @initDownloadButtons()
    @initZoomModal()

  events: ->
    "click #CNC-3d-modal-trigger": "init3DView"

  renderImage: ->
    if @model.get('structure_type') == 'NONE'
      img_url = '/static/img/structure_not_available.png'
    else if @model.get('structure_type') == 'SEQ'
      img_url = '/static/img/protein_structure.png'
    else
      img_url = Settings.WS_BASE_URL + 'image/' + @model.get('molecule_chembl_id') + '.svg'

    img = $(@el).find('#Bck-COMP_IMG')
    img.load $.proxy(@showVisibleContent, @)

    # protein_structure is used when the molecule has a very complex structure that can not be shown in an image.
    # not_available is when the compound has no structure to show.
    # not_found is when there was an error loading the image
    img.error ->
      img.attr('src', '/static/img/structure_not_found.png')

    img.attr('src', img_url)


  initDownloadButtons: ->
    img_url = Settings.WS_BASE_URL + 'image/' + @model.get('molecule_chembl_id')
    $('.CNC-download-png').attr('href', img_url + '.png')
    $('.CNC-download-png').attr('download', @model.get('molecule_chembl_id') + '.png')

    $('.CNC-download-svg').attr('href', img_url + '.svg')
    $('.CNC-download-svg').attr('download', @model.get('molecule_chembl_id') + '.svg')

  initZoomModal: ->

    # If the image strcuture can't be shown, don't activate the zoom modal.
    img = $(@el).find('#Bck-COMP_IMG')
    if img.attr('src').indexOf('/static/') > -1
      $('#CNC-IMG-Options-Zoom, #CNC-IMG-Options-Zoom-small').remove()
      return

    modal = $(@el).find('#CNC-zoom-modal')

    title = modal.find('h3')
    title.text(@model.get('molecule_chembl_id'))

    img = modal.find('#Bck-Comp-Img-zoom')

    img.load ->

      $('#Bck-Comp-Img-zoom-preloader').hide()
      $(@).show()

    img.attr('src', Settings.WS_BASE_URL + 'image/' + @model.get('molecule_chembl_id') + @getParamsFromSwitches())
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
      img.attr('src', Settings.WS_BASE_URL + 'image/' + parentView.model.get('molecule_chembl_id') + parentView.getParamsFromSwitches())



  getParamsFromSwitches: ->
    renderer = 'engine=' + if $('#Bck-Renderer-Switch').prop('checked') then 'indigo' else 'rdkit'
    format = 'format=' + if $('#Bck-Format-Switch').prop('checked') then 'png' else 'svg'
    coords = if $('#Bck-Coordinates-Switch').prop('checked') then 'ignoreCoords=1' else ''

    return '?' + renderer + '&' + format + '&' + coords

  init3DView: ->

    comp3DView = new Compound3DView
      el: $('#BCK-compound-3dview')
      model: @model
      type: 'reduced'





