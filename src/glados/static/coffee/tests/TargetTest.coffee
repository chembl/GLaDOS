describe "Target", ->

  describe "Target Model", ->

    target = new Target
        target_chembl_id: 'CHEMBL2363965'

    beforeAll (done) ->
      target.fetch()

      # this timeout is to give time to get the
      # target classification information, it happens after the fetch,
      # there is a way to know that it loaded at least one classification: get('protein_classifications_loaded')
      # but there is no way to know that it loaded all the classifications.
      setTimeout ( ->
        done()
      ), 10000

    it "(SERVER DEPENDENT) loads the protein target classification", (done) ->
      classification = target.get('protein_classifications')
      class1 = classification[8][0]
      class2 = classification[601][0]
      expect(class1).toBe('Other cytosolic protein')
      expect(class2).toBe('Unclassified protein')

      done()