describe "Compound", ->

  describe "Compound Model", ->

    describe "Loaded From Elastic Search", ->

      compound = new Compound
        molecule_chembl_id: 'CHEMBL25'

      it 'parses the data from elastic correctly', ->

        

