describe "Compound", ->

  describe "Molecule Features", ->

    it "Doesn't have any cat icon", ->

      featuresDictionary = CompoundFeaturesView.prototype.molFeatures
      for key, valuesDict of featuresDictionary

        for valueKey, iconDescription of valuesDict
          iconLetter = iconDescription[1]
          fontFamily = iconDescription[4]
          isCat = iconLetter == 'A' and fontFamily == 'icon-species'

          expect(isCat).toBe(false)
