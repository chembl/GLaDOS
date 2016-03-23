# Base view for most of the cards in the page
CardView = Backbone.View.extend

  showCompoundErrorCard: (model, xhr, options) ->
    $(@el).children('.card-preolader-to-hide').hide()

    if xhr.status == 404
      error_msg = 'No compound found with id ' + @model.get('molecule_chembl_id')
    else
      error_msg = 'There was an error while loading the compound (' + xhr.status + ' ' + xhr.statusText + ')'

    source = '<i class="fa fa-exclamation-circle"></i> {{msg}}'
    rendered = Handlebars.compile(source)
      msg: error_msg

    $(@el).children('.card-load-error').find('.Bck-errormsg').html(rendered)

    $(@el).children('.card-load-error').show()

    $(@el).find('#Bck-CHEMBL_ID')

  initEmbedModal: (section_name) ->

    modal_trigger = $(@el).find('.embed-modal-trigger')

    modal = $(@el).find('.embed-modal')
    modal_id = 'embed-modal-for-' + $(@el).attr('id')
    modal.attr('id', modal_id)
    modal_trigger.attr('href', '#' + modal_id)

    code_elem = modal.find('code')

    source = '<object ' +
             'data="http://glados-ebitest.rhcloud.com//compound_report_card/{{chembl_id}}/embed/{{section_name}}/" ' +
             'width="360px" height="600px"></object>'

    rendered = Handlebars.compile(source)
      chembl_id: @model.get('molecule_chembl_id')
      section_name: section_name



    code_elem.text(rendered)

  renderModalPreview: ->

    modal = $(@el).find('.embed-modal')
    preview_elem = modal.find('.embed-preview')

    code_elem = modal.find('code')
    code_to_preview = code_elem.text()

    preview_elem.html(code_to_preview)

