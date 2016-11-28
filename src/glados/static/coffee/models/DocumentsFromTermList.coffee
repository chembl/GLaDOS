DocumentsFromTermList = PaginatedCollection.extend

  model: Document

  initUrl: (term) ->

    @baseUrl = Settings.WS_BASE_URL + 'document_term.json?term_text=' + term + '&order_by=-score'
    @setMeta('base_url', @baseUrl, true)
    @initialiseSSUrl()

  fetch: ->

    @reset()
    url = @getPaginatedURL()
    documents = []
    totalDocs = 0
    receivedDocs = 0
    # 1 first get list of documents
    getDocuments = $.getJSON(url)

    thisCollection = @
    # 3. check that everything is ready
    checkAllInfoReady = ->
      if receivedDocs == totalDocs
        console.log 'ALL READY!'
        thisCollection.trigger('do-repaint')

    getDocuments.done( (data) ->

      data.page_meta.records_in_page = data.document_terms.length
      thisCollection.resetMeta(data.page_meta)

      documents = data.document_terms
      totalDocs = documents.length

      # 2. get details per document
      for docInfo in documents

        doc = new Document(docInfo)
        thisCollection.add doc
        doc.fetch
          success: ->
            receivedDocs += 1
            checkAllInfoReady()

    )

    getDocuments.fail ->

      console.log 'ERROR!'

  initialize: ->

    @meta =
      server_side: true
      #base_url is set by initURL
      page_size: 25
      current_page: 1
      available_page_sizes: Settings.TABLE_PAGE_SIZES
      to_show: []
      columns: [
        {
          'name_to_show': 'CHEMBL_ID'
          'comparator': 'document_chembl_id'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
          'link_base': '/document_report_card/$$$'
        }
        {
          'name_to_show': 'Score'
          'comparator': 'score'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
          'custom_field_template': '<b>Score: </b>{{val}}'
        }
        {
          'name_to_show': 'Title'
          'comparator': 'title'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
          'custom_field_template': '<i>{{val}}</i>'
        }
        {
          'name_to_show': 'Authors'
          'comparator': 'authors'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
        {
          'name_to_show': 'Year'
          'comparator': 'year'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'

        }
      ]
