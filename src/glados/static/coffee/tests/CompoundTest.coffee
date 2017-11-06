describe "Compound", ->

  describe "Compound Model", ->

    describe "Loaded From Web Services", ->

      chemblID = 'CHEMBL25'
      compound = new Compound
        molecule_chembl_id: chemblID

      it 'generates the web services url', ->

        urlMustBe = glados.Settings.WS_BASE_URL + 'molecule/' + chemblID + '.json'
        expect(compound.url).toBe(urlMustBe)

    describe "Loaded From Elastic Search", ->

      compound = new Compound
        molecule_chembl_id: 'CHEMBL25'
        fetch_from_elastic: true

      it 'parses the data from elastic correctly', ->



