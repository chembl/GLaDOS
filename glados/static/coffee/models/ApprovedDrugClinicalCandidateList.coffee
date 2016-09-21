ApprovedDrugClinicalCandidateList = PaginatedCollection.extend(DownloadModelOrCollectionExt).extend

  model: ApprovedDrugClinicalCandidate


  fetch: ->

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

    base_url2 = Settings.WS_BASE_URL + 'molecule.json?molecule_chembl_id__in='
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
          'link_base': '/compound_report_card/$$$'
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







