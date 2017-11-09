describe 'Scroll Spy Handler', ->

  scrollSpHandler = new glados.models.ScrollSpy.ScrollSpyHandler

  it 'initializes the structure', ->
    sections = scrollSpHandler.get('sections')
    expect(_.isObject(sections)).toBe(true)

