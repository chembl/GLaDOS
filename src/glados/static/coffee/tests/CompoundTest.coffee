describe "Compound", ->

  describe "Compound Model", ->

    #-------------------------------------------------------------------------------------------------------------------
    # Generic Testing functions
    #-------------------------------------------------------------------------------------------------------------------
    testBasicProperties = (response, parsed) ->

      for propKey, propVal of response

        if not popVal?
          expect(parsed[propVal]?).toBe(false)
        else if _.isNumber(popVal) or _.isSring(propVal) or _.isBoolean(propVal)
          expect(response[propVal]).toBe(parsed[propVal])
        # propably later check objects and arrays

    testActivitiesURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      activitiesURLMustBe = Activity.getActivitiesListURL('molecule_chembl_id:' + chemblID)
      expect(parsed.activities_url).toBe(activitiesURLMustBe)

    testSDFURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      sdfURLMustBe = glados.Settings.WS_BASE_URL + 'molecule/' + chemblID + '.sdf'
      expect(parsed.sdf_url).toBe(sdfURLMustBe)

    testRo5Pass = (response, parsed) ->

      ro5Pass = response.molecule_properties.num_ro5_violations == 0
      expect(parsed.ro5).toBe(ro5Pass)

    testReportCardURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      reportCardURLMustBe = Compound.get_report_card_url(chemblID)
      expect(parsed.report_card_url).toBe(reportCardURLMustBe)

    testRelatedTargetsURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      urlMustBe = Target.getTargetsListURL('_metadata.related_compounds.chembl_ids.\\*:' + chemblID)
      expect(parsed.targets_url).toBe(urlMustBe)

    testHasNormalImageURL = (response, parsed) ->

      chemblID = response.molecule_chembl_id
      imageURLMustBe = glados.Settings.WS_BASE_URL + 'image/' + chemblID + '.svg?engine=indigo'
      expect(parsed.image_url).toBe(imageURLMustBe)

    testHasMetalContainingIMG = (response, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/metalContaining.png'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasOligosaccharideIMG = (response, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligosaccharide.png'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasNaturlaProductIMG = (response, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/naturalProduct.svg'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasSmallPolymerIMG = (response, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolPolymer.png'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasSmallMoleculeIMG = (response, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/smallMolecule.svg'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasAntibodyIMG = (wsResponse, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/antibody.svg'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasProteinIMG = (wsResponse, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/peptide.png'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasOligonucleotideIMG = (wsResponse, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/oligonucleotide.png'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasEnzymeIMG = (wsResponse, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/enzyme.svg'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasCellIMG = (wsResponse, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/cell.png'
      expect(parsed.image_url).toBe(imgURLMustBe)

    testHasUnknownTypeIMG = (wsResponse, parsed) ->

      imgURLMustBe = glados.Settings.STATIC_IMAGES_URL + 'compound_placeholders/unknown.svg'
      expect(parsed.image_url).toBe(imgURLMustBe)
    #-------------------------------------------------------------------------------------------------------------------
    # Specific cases
    #-------------------------------------------------------------------------------------------------------------------
    describe "Loaded From Web Services", ->

      chemblID = 'CHEMBL25'
      compound = new Compound
        molecule_chembl_id: chemblID
        fetch_from_elastic: false

      wsResponse = undefined
      parsed = undefined

      beforeAll (done) ->

        dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL25wsResponse.json'
        $.get dataURL, (testData) ->
          wsResponse = testData
          parsed = compound.parse(wsResponse)
          done()

      it 'generates the web services url', ->

        urlMustBe = glados.Settings.WS_BASE_URL + 'molecule/' + chemblID + '.json'
        expect(compound.url).toBe(urlMustBe)

      it 'parses the basic information received from web services', -> testBasicProperties(wsResponse, parsed)
      it 'parses the activities URL', -> testActivitiesURL(wsResponse, parsed)
      it 'parses the sdf URL', -> testSDFURL(wsResponse, parsed)
      it 'parses Rule of 5 pass', -> testRo5Pass(wsResponse, parsed)
      it 'parses the report card url', -> testReportCardURL(wsResponse, parsed)
      it 'parses the related targets url', -> testRelatedTargetsURL(wsResponse, parsed)
      it 'parses a normal image url', -> testHasNormalImageURL(wsResponse, parsed)

      describe 'Metal Containing', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL364516MetalContainingwsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasMetalContainingIMG(wsResponse, parsed)

      describe 'Oligosaccharide', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2108122OligosaccharidgewsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasOligosaccharideIMG(wsResponse, parsed)

      describe 'Natural Product', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL1201454NaturalProductwsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasNaturlaProductIMG(wsResponse, parsed)

      describe 'Small Polymer', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2108458SmallPolymerwsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasSmallPolymerIMG(wsResponse, parsed)

      describe 'Small Molecule', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL3544956smallMoleculewsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasSmallMoleculeIMG(wsResponse, parsed)

      describe 'Antibody', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2109414AntibodywsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasAntibodyIMG(wsResponse, parsed)


      describe 'Protein', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL1201644proteinwsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasProteinIMG(wsResponse, parsed)

      describe 'Oligonucleotide', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL3545182OligonucleotidewsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasOligonucleotideIMG(wsResponse, parsed)


      describe 'Enzyme', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2107858EnzymewsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasEnzymeIMG(wsResponse, parsed)

      describe 'Unknown Type', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2109133UnknownwsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasUnknownTypeIMG(wsResponse, parsed)

      describe 'Cell', ->

        beforeAll (done) ->

          dataURL = glados.Settings.STATIC_URL + 'testData/Compounds/CHEMBL2107865CellwsResponse.json'
          $.get dataURL, (testData) ->
            wsResponse = testData
            parsed = compound.parse(wsResponse)
            done()

        it 'generates the correct Image', -> testHasCellIMG(wsResponse, parsed)

    describe "Loaded From Elastic Search", ->

      chemblID = 'CHEMBL25'
      compound = new Compound
        molecule_chembl_id: chemblID
        fetch_from_elastic: true

      it 'generates the elasctisearch url', ->

        console.log 'compound url: ', compound.url
        urlMustBe = glados.models.paginatedCollections.Settings.ES_BASE_URL + '/chembl_molecule/molecule/' + chemblID
        expect(compound.url).toBe(urlMustBe)



