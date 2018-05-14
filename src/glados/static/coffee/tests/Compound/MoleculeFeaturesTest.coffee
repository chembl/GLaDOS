describe "Compound", ->

  describe "Molecule Features", ->

    it "Doesn't have any cat icon", ->

      featuresDictionary = CompoundFeaturesView.prototype.molFeatures
      console.log 'featuresDictionary: ', featuresDictionary
      for key, valuesDict of featuresDictionary

        console.log 'key: ', key
        for valueKey, iconDescription of valuesDict
          iconLetter = iconDescription[1]
          fontFamily = iconDescription[4]
          isCat = iconLetter == 'A' and fontFamily == 'icon-species'
          console.log 'isCat: ', isCat

          expect(isCat).toBe(true)
