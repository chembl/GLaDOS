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
      columns: [
        {
          'name_to_show': 'ChEMBL ID'
          'comparator': 'molecule_chembl_id'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
        {
          'name_to_show': 'Name'
          'comparator': 'pref_name'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
        {
          'name_to_show': 'Mechanism of Action'
          'comparator': 'mechanism_of_action'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
        {
          'name_to_show': 'Max Phase'
          'comparator': 'max_phase'
          'sort_disabled': false
          'is_sorting': 0
          'sort_class': 'fa-sort'
        }
        {
          'name_to_show': 'References'
          'comparator': 'references'
          'sort_disabled': true
          'is_sorting': 0
        }
      ]


    @on 'reset', @resetMeta, @

  setMeta: (attr, value) ->
    @meta[attr] = parseInt(value)
    @trigger('meta-changed')

  getMeta: (attr) ->
    return @meta[attr]

  resetPageSize: (new_page_size) ->

    if new_page_size == ''
      return

    @setMeta('page_size', new_page_size)
    @setMeta('current_page', 1)
    @calculateTotalPages()
    @calculateHowManyInCurrentPage()
    @trigger('do-repaint')

  # assuming that I have all the records.
  resetMeta: ->

    @setMeta('total_records', @models.length)
    @setMeta('current_page', 1)
    @calculateTotalPages()
    @calculateHowManyInCurrentPage()
    @resetSortData()

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

    page_size = @getMeta('page_size')
    current_page = @getMeta('current_page')
    records_in_page = @getMeta('records_in_page')

    start = (current_page - 1) * page_size
    end = start + records_in_page

    to_show = @models[start..end]
    @setMeta('to_show', to_show)
    return to_show


  setPage: (page_num) ->

    @setMeta('current_page', page_num)
    @trigger('do-repaint')

  sortCollection: (comparator) ->

    console.log('sort')
    @comparator = comparator
    columns = @getMeta('columns')
    is_descending = false

    for col in columns

      # set is_sorting attribute for the comparator column
      if col.comparator == comparator

        col.is_sorting = switch col.is_sorting
          when 0 then 1
          else -col.is_sorting

        is_descending = col.is_sorting == -1

      else
      # for the rest of the columns is zero
        col.is_sorting = 0

      # now set the class for font-awesome
      # this was the simplest way I found to fo it, handlebars doesn't provide a '==' expression

      col.sort_class = switch col.is_sorting
        when -1 then 'fa-sort-desc'
        when 0 then 'fa-sort'
        when 1 then 'fa-sort-asc'


    # check if sorting is descending
    if is_descending
      @sort({silent: true})
      @models = @models.reverse()
      @trigger('sort')
    else
      @sort()


  resetSortData: ->

    @comparator = undefined
    columns = @getMeta('columns')
    for col in columns
      col.is_sorting = 0
      col.sort_class = 'fa-sort'


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





