Compound3DView = Backbone.View.extend

  initialize: (options) ->
    @model.on 'change', @.render, @
    @type = options.type

    @getCoords()


  events: ->
    'click #BCK-Compound-3d-speckpresets input': 'selectPreset'

  render: ->

    $(@el).html Handlebars.compile($(typeToTemplate[@type]).html())
      title: '3D View of ' + @model.get('molecule_chembl_id')

    @molVis = new MoleculeVisualisator("render-container", "renderer-canvas", @model.get('xyz'))


  showError: ->
    $(@el).html Handlebars.compile($('#Handlebars-Compound-3D-error').html())
      msg: 'There was en error loading the data'


  getCoords: ->

    standardInchi = @model.get('molecule_structures')['standard_inchi']
    standardInchiB64 = window.btoa(standardInchi)

    molUrl = 'https://www.ebi.ac.uk/chembl/api/utils/inchi2ctab/' + standardInchiB64

    # from a ctab value it returns the base64 url to get the xyz
    getXYZURL = (data) ->
      ctabB64 = window.btoa(data)
      xyzUrl = 'https://www.ebi.ac.uk/chembl/api/utils/ctab2xyz/' + ctabB64
      return xyzUrl

    getXZYcontent = (url) ->
      $.ajax( url )

    setXYZToModel = (xyzCoords) ->
      @model.set('xyz', xyzCoords)

    f = $.proxy(setXYZToModel, @)

    getCoords = $.ajax( molUrl ).then(getXYZURL).then(getXZYcontent).then(f)

    e = $.proxy(@showError, @)
    getCoords.fail ->
      e()


  selectPreset: (event) ->
    value = $(event.currentTarget).val()
    @molVis.changePreset(value);

  typeToTemplate:
    'reduced': '#Handlebars-Compound-3D-speck'




