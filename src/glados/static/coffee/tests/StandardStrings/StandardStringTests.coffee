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
