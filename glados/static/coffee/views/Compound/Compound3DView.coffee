Compound3DView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @.render, @
    @getCoords()


  render: ->

    #url = 'https://www.ebi.ac.uk/chembl/api/utils/ctab2xyz/CiAgU2NpVGVnaWMwMTExMTYxMzQ0MkQKCiAxMyAxMyAgMCAgMCAgMCAgMCAgICAgICAgICAgIDk5OSBWMjAwMAogICAgMS4yOTkwICAgLTAuNzUwMCAgICAwLjAwMDAgQyAgIDAgIDAKICAgIDEuMjk5MCAgICAwLjc1MDAgICAgMC4wMDAwIEMgICAwICAwCiAgICAwLjAwMDAgICAgMS41MDAwICAgIDAuMDAwMCBDICAgMCAgMAogICAtMS4yOTkwICAgIDAuNzUwMCAgICAwLjAwMDAgQyAgIDAgIDAKICAgLTEuMjk5MCAgIC0wLjc1MDAgICAgMC4wMDAwIEMgICAwICAwCiAgICAwLjAwMDAgICAtMS41MDAwICAgIDAuMDAwMCBDICAgMCAgMAogICAgMC4wMDMxICAgLTMuMDAwOCAgICAwLjAwMDAgQyAgIDAgIDAKICAgLTEuMDM1MSAgIC0zLjYwMjYgICAgMC4wMDAwIE8gICAwICAwCiAgICAxLjA0MzIgICAtMy41OTkzICAgIDAuMDAwMCBPICAgMCAgMAogICAtMi42MDAzICAgLTEuNDk3OCAgICAwLjAwMDAgTyAgIDAgIDAKICAgLTMuODk5MCAgIC0wLjc0NTUgICAgMC4wMDAwIEMgICAwICAwCiAgIC0zLjg5NjkgICAgMC40NTQ1ICAgIDAuMDAwMCBDICAgMCAgMAogICAtNC45Mzk1ICAgLTEuMzQzNCAgICAwLjAwMDAgTyAgIDAgIDAKICAxICAyICAyICAwCiAgMiAgMyAgMSAgMAogIDMgIDQgIDIgIDAKICA0ICA1ICAxICAwCiAgNSAgNiAgMiAgMAogIDYgIDEgIDEgIDAKICA2ICA3ICAxICAwCiAgNyAgOCAgMSAgMAogIDcgIDkgIDIgIDAKICA1IDEwICAxICAwCiAxMCAxMSAgMSAgMAogMTEgMTIgIDEgIDAKIDExIDEzICAyICAwCk0gIEVORA=='


    MoleculeVisualisator.initVsualisationFromData("render-container", "renderer-canvas", @model.get('xyz'));

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
      console.log(@model.get('xyz'))

    f = $.proxy(setXYZToModel, @)

    $.when( $.ajax( molUrl ) ).then(getXYZURL).then(getXZYcontent).then(f)