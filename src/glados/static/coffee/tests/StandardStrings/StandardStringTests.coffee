describe 'Standard Strings', ->

  standardStringsMustBe = undefined

  beforeAll (done) ->

    dataURL = "#{glados.Settings.STATIC_URL}testData/StandardStrings/StandardStringsMustBe.json"
    $.get dataURL, (testData) ->
      standardStringsMustBe = testData
      done()

  it 'The number of standard Strings has not changed', ->

    numStandardStringsMusBe = _.keys(django.catalog).length
    numStandardStringsGot = _.keys(standardStringsMustBe).length

    expect(numStandardStringsGot).toBe(numStandardStringsMusBe)

  it 'The standard strings have not changed', ->

    for key, value of standardStringsMustBe
      expect(django.catalog[key]).toBe(value)
