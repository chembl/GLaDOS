ApprovedDrugClinicalCandidateList = Backbone.Collection.extend

  model: ApprovedDrugClinicalCandidate

  fetch: ->

    pag_url = @getPaginatedURL(@url)
    console.log('fetching:')
    console.log(pag_url)
    this_collection = @
    drug_mechanisms = {}

    # 1 first get list of drug mechanisms
    getDrugMechanisms = $.getJSON(pag_url, (data) ->
      drug_mechanisms = data.mechanisms
      this_collection.setMeta('total_records', data.page_meta.total_count)
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

  setMeta: (attr, value) ->
    @meta[attr] = value
    @trigger('meta-changed')

  getMeta: (attr) ->
    return @meta[attr]

  getPaginatedURL: (url) ->

    page_size = @getMeta('page_size')
    current_page = @getMeta('current_page')

    limit_str = 'limit=' + page_size
    page_str = 'offset=' + (current_page - 1) * page_size

    return url + '&' + limit_str + '&' + page_str


  fetchPage: (page_num, force) ->

    @setMeta('current_page', page_num)
    @fetch()



