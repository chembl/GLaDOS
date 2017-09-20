describe 'Aggregation', ->

  describe 'with a numeric property', ->

    associatedCompoundsAggregation = undefined

    beforeAll ->

      associatedCompoundsAggregation = new glados.models.Aggregations.Aggregation()

    it 'works', ->
      console.log 'works'

