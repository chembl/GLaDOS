# View that renders the Document basic information section
# from the Document report card
# load CardView first!
# also make sure the html can access the handlebars templates!
DocumentBasicInformationView = CardView.extend(DownloadViewExt).extend

  initialize: ->
    @model.on 'change', @.render, @
    @model.on 'error', @.showCompoundErrorCard, @
    @resource_type = 'Document'

  render: ->

    @fillTemplate('BCK-DBI-large')
    @fillTemplate('BCK-DBI-small')
    @showVisibleContent()

    @initEmbedModal('basic_information')
    @activateModals()

  fillTemplate: (div_id) ->

    div = $(@el).find('#' + div_id)
    template = $('#' + div.attr('data-hb-template'))

    div.html Handlebars.compile(template.html())
      doc_id: @model.get('document_chembl_id')
      journal: @model.get('journal')
      year: @model.get('year')
      volume: @model.get('volume')
      first_page: @model.get('first_page')
      last_page: @model.get('last_page')
      pubmed_id: @model.get('pubmed_id')
      doi: @model.get('doi')

  # --------------------------------------------------------------------
  # Downloads
  # --------------------------------------------------------------------

  getFilename: (format) ->

    if format == 'csv'
      return @model.get('document_chembl_id') + 'DocumentBasicInformation.csv'
    else if format == 'json'
      return @model.get('document_chembl_id') + 'DocumentBasicInformation.json'
    else if format == 'xlsx'
      return @model.get('document_chembl_id') + 'DocumentBasicInformation.xlsx'
    else
      return 'file.txt'