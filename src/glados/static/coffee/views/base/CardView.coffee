# Base view for most of the cards in the page
# make sure the handlebars templates are loaded!
CardView = Backbone.View.extend

  showCompoundErrorCard: (model, xhr, options) ->

    $(@el).children('.card-preolader-to-hide').hide()

    if xhr.status == 404

      switch @resource_type
        when 'Compound' then error_msg = 'No compound found with id ' + @model.get('molecule_chembl_id')
        when 'Target' then error_msg = 'No target found with id ' + @model.get('target_chembl_id')
        when 'Cell Line' then error_msg = 'No cell line found with id ' + @model.get('cell_chembl_id')
        when 'Assay' then error_msg = 'No assay found with id ' + @model.get('assay_chembl_id')
        when 'Document' then error_msg = 'No document found with id ' + @model.get('document_chembl_id')

    else
      error_msg = 'There was an error while loading the data (' + xhr.status + ' ' + xhr.statusText + ')'

    rendered = Handlebars.compile($('#Handlebars-Common-CardError').html())
      msg: error_msg

    $(@el).children('.card-load-error').find('.Bck-errormsg').html(rendered)

    $(@el).children('.card-load-error').show()


  initEmbedModal: (section_name) ->

    if EMBEDED?
      # prevent unnecessary loops
      $(@el).find('.embed-modal-trigger').remove()
      $(@el).find('.embed-modal').remove()
      return

    modal_trigger = $(@el).find('.embed-modal-trigger')

    modal = $(@el).find('.embed-modal')
    modal_id = 'embed-modal-for-' + $(@el).attr('id')
    modal.attr('id', modal_id)
    modal_trigger.attr('href', '#' + modal_id)
    modal_trigger.attr('rendered', 'false')
    modal_trigger.attr('data-embed-sect-name', section_name)
    modal_trigger.attr('data-resource-type', @resource_type.toLowerCase().replace(' ','_'))

    modal_trigger.click @renderModalPreview


  # this function is to be used for the click event in the embed modal button.
  # it can get all the information needed from the clicked element, no closure is needed.
  renderModalPreview: ->

    clicked = $(@)
    if clicked.attr('rendered') == 'true'
      return

    section_name = clicked.attr('data-embed-sect-name')
    modal = $(clicked.attr('href'))

    code_elem = modal.find('code')
    chembl_id = if @model? then @model.get('molecule_chembl_id') else GlobalVariables.CHEMBL_ID

    rendered = Handlebars.compile($('#Handlebars-Common-EmbedCode').html())
      base_url: Settings.EMBED_BASE_URL
      chembl_id: chembl_id
      chembl_id: chembl_id
      section_name: section_name
      resource_type: clicked.attr('data-resource-type')

    code_elem.text(rendered)
    preview_elem = modal.find('.embed-preview')

    code_elem = modal.find('code')
    code_to_preview = code_elem.text()

    preview_elem.html(code_to_preview)


    clicked.attr('rendered', 'true')


  activateTooltips: ->
    $(@el).find('.tooltipped').tooltip()

  activateModals: ->
    $(@el).find('.modal-trigger').leanModal();


  showCardContent: ->
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error, .modal)').show()

  showCardPreloader: ->
    $(@el).children('.card-preolader-to-hide').show()
    $(@el).children(':not(.card-preolader-to-hide)').hide()






