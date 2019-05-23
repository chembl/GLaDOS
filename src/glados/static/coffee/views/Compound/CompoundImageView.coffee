# View that renders the Image of the compound for the Compound Name and Classification Section
CompoundImageView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @

  render: ->

    @renderImage()
    @renderStructureSearchButton()

  events:
    'click .BCK-open-structure-editor': 'openEditor'

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

  renderStructureSearchButton: ->

    hasStructure = @model.get('structure_image')
    $structureSearchBTNContainer = $(@el).find('.BCK-Structure-Search-BTN-container')
    if hasStructure
      glados.Utils.fillContentForElement($structureSearchBTNContainer)

