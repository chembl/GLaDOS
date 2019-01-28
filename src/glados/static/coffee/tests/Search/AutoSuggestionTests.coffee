describe 'Search Autosuggestion', ->

  searchModel = undefined
  beforeEach ->
    searchModel = SearchModel.getTestInstance()

  it 'sets up the initial state for the autosuggestion', ->

    stateGot = searchModel.get('autosuggestion_state')
    stateMustBe = SearchModel.AUTO_SUGGESTION_STATES.INITIAL_STATE

    expect(stateGot).toBe(stateMustBe)

  it 'switches to requesting state after requesting suggestions', ->

    searchModel.requestAutocompleteSuggestions('SomeTerm', @)
    stateGot = searchModel.get('autosuggestion_state')
    stateMustBe = SearchModel.AUTO_SUGGESTION_STATES.REQUESTING_SUGGESTIONS

    expect(stateGot).toBe(stateMustBe)

    # the final state can no t be tested easily.

  it 'triggers the requesting event when suggestions are requested', ->

    eventTriggered = false
    searchModel.once SearchModel.EVENTS.SUGGESTIONS_REQUESTED, (-> eventTriggered = true)
    searchModel.requestAutocompleteSuggestions('SomeTerm', @)
    expect(eventTriggered).toBe(true)