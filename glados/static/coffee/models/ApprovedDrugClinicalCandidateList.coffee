ApprovedDrugClinicalCandidateList = Backbone.Collection.extend

  model: ApprovedDrugClinicalCandidate


  fetch: ->


    console.log('fetching:')
    console.log(@url)
    this_collection = @
    drug_mechanisms = {}

    # 1 first get list of drug mechanisms
    getDrugMechanisms = $.getJSON(@url, (data) ->
      drug_mechanisms = data.mechanisms
    )

    getDrugMechanisms.fail( ()->

      console.log('error')
      this_collection.trigger('error')

    )

    base_url2 = 'https://www.ebi.ac.uk/chembl/api/data/molecule.json?molecule_chembl_id__in='
    # after I have the drug mechanisms now I get the molecules
    getDrugMechanisms.done(() ->

      molecules_list = (dm.molecule_chembl_id for dm in drug_mechanisms).join(',')
      # order is very important to iterate in the same order as the first call
      getMoleculesInfoUrl = base_url2 + molecules_list + '&order_by=molecule_chembl_id&limit=1000'
      console.log(getMoleculesInfoUrl)

      getMoleculesInfo = $.getJSON(getMoleculesInfoUrl, (data) ->

        molecules = data.molecules
        # Now I fill the missing information, both arrays are ordered by molecule_chembl_id
        i = 0
        for mol in molecules

          drug_mechanisms[i].max_phase = mol.max_phase
          drug_mechanisms[i].pref_name = mol.pref_name

          i++

        # here everything is ready
        this_collection.reset(drug_mechanisms)

      )

      getMoleculesInfo.fail( ()->

        console.log('failed2')

      )


    )


  initialize: ->
    @meta =
      page_size: 10
      current_page: 1
      to_show: []

    @on 'reset', @resetMeta, @

  setMeta: (attr, value) ->
    @meta[attr] = parseInt(value)
    @trigger('meta-changed')

  getMeta: (attr) ->
    return @meta[attr]

  resetPageSize: (new_page_size) ->

    if new_page_size == ''
      return

    console.log('new page size')
    console.log(new_page_size)
    @setMeta('page_size', new_page_size)
    @setMeta('current_page', 1)
    @calculateTotalPages()
    @calculateHowManyInCurrentPage()
    @trigger('do-repaint')


  # assuming that I have all the records.
  resetMeta: ->

    console.log('resetting!')
    @setMeta('total_records', @models.length)
    @setMeta('current_page', 1)
    @calculateTotalPages()
    @calculateHowManyInCurrentPage()

  calculateTotalPages: ->

    total_pages =  Math.ceil(@models.length / @getMeta('page_size'))

    @setMeta('total_pages', total_pages)

  calculateHowManyInCurrentPage: ->

    current_page = @getMeta('current_page')
    total_pages = @getMeta('total_pages')
    total_records = @getMeta('total_records')
    page_size = @getMeta('page_size')

    if current_page == total_pages
      @setMeta('records_in_page', total_records % page_size)
    else
      @setMeta('records_in_page', @getMeta('page_size'))



  getCurrentPage: ->

    console.log('Returning current page ')
    page_size = @getMeta('page_size')
    current_page = @getMeta('current_page')
    records_in_page = @getMeta('records_in_page')
    console.log('current page is: ', current_page)
    console.log('page size is: ', page_size)

    start = (current_page - 1) * page_size
    end = start + records_in_page

    console.log('start: ' + start)
    console.log('end: ' + end)

    to_show = @models[start..end]
    @setMeta('to_show', to_show)
    return to_show


  setPage: (page_num) ->

    console.log('changing to page: ' + page_num)
    @setMeta('current_page', page_num)
    console.log('^^^')
    @trigger('do-repaint')



  #
  getPaginatedURL: (url) ->

    page_size = @getMeta('page_size')
    current_page = @getMeta('current_page')

    limit_str = 'limit=' + page_size
    page_str = 'offset=' + (current_page - 1) * page_size

    return url + '&' + limit_str + '&' + page_str


  fetchPage: (page_num, force) ->

    @setMeta('current_page', page_num)
    @fetch()





