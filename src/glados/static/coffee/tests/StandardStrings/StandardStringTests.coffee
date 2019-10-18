describe 'Standard Strings', ->

  standardStringsMustBe = undefined

  beforeAll (done) ->

    dataURL = "#{glados.Settings.STATIC_URL}testData/StandardStrings/StandardStringsMustBe.json"
    $.get dataURL, (testData) ->
      standardStringsMustBe = testData
      done()

  it 'The number of standard Strings is below expected', ->

    numStandardStringsGot= _.keys(django.catalog).length
    numStandardStringsMusBe = _.keys(standardStringsMustBe).length
    expect(numStandardStringsGot >= numStandardStringsMusBe).toBe(true)

  it 'The standard strings have not changed', ->

    for key, value of standardStringsMustBe
      expect(django.catalog[key]).toBe(value)
