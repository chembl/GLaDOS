# Base view for most of the cards in the page
# make sure the handlebars templates are loaded!
CardView = Backbone.View.extend

  initialize: (originalArguments) ->
    @config ?= {}

    unless GlobalVariables['EMBEDED'] or @config.is_outside_an_entity_report_card
      @sectionID = originalArguments[0].section_id
      @sectionLabel = originalArguments[0].section_label
      @reportCardApp = originalArguments[0].report_card_app
      @reportCardApp.registerSection(@sectionID, @sectionLabel)

  showSection: -> @reportCardApp.showSection(@sectionID) unless GlobalVariables['EMBEDED']
  hideSection: -> @reportCardApp.hideSection(@sectionID) unless GlobalVariables['EMBEDED']
  updateSectionTitle: (newSectionLabel) ->
    @sectionLabel = newSectionLabel
    @reportCardApp.updateSectionTitle(@sectionID, @sectionLabel) unless GlobalVariables['EMBEDED']

  showCompoundErrorCard: (model, xhr, options) ->

    $(@el).find('.card-preolader-to-hide').hide()

    if xhr.status == 404

      switch @resource_type
        when 'Compound' then error_msg = 'No compound found with id ' + model.get('molecule_chembl_id')
        when 'Target' then error_msg = 'No target found with id ' + model.get('target_chembl_id')
        when 'Cell Line' then error_msg = 'No cell line found with id ' + model.get('cell_chembl_id')
        when 'Assay' then error_msg = 'No assay found with id ' + model.get('assay_chembl_id')
        when 'Document' then error_msg = 'No document found with id ' + model.get('document_chembl_id')

    else
      error_msg = 'There was an error while loading the data (' + xhr.status + ' ' + xhr.statusText + ')'

    rendered = Handlebars.compile($('#Handlebars-Common-CardError').html())
      msg: error_msg

    $(@el).find('.card-load-error').find('.Bck-errormsg').first().html(rendered)
    $(@el).find('.card-load-error').first().show()

  initEmbedModal: (sectionName, chemblID) ->

    if @config.is_outside_an_entity_report_card
      embedURL = @config.embed_url
    else
      embedURL = "#{glados.Settings.GLADOS_BASE_URL_FULL}embed/##{@resource_type.toLowerCase().replace(' ','_')}_report_card/#{chemblID}/#{sectionName}"
    glados.helpers.EmbedModalsHelper.initEmbedModal($(@el), embedURL)

  activateTooltips: ->
    $(@el).find('.tooltipped').tooltip()

  activateModals: ->
    $(@el).find('.modal').modal()

  showCardContent: ->
    $(@el).children('.card-preolader-to-hide').hide()
    $(@el).children(':not(.card-preolader-to-hide, .card-load-error, .modal)').show()

  showCardPreloader: ->
    $(@el).children('.card-preolader-to-hide').show()
    $(@el).children(':not(.card-preolader-to-hide)').hide()