describe 'Search Autosuggestion', ->

  searchModel = undefined
  beforeEach ->
    searchModel = SearchModel.getTestInstance()

  it 'sets up the initial state for the autosuggestion', ->

    stateGot = searchModel.get('autosuggestion_state')
    stateMustBe = SearchModel.AUTO_SUGGESTION_STATES.INITIAL_STATE

    expect(stateGot).toBe(stateMustBe)