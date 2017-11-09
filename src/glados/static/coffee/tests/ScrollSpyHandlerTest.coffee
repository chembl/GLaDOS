describe 'Scroll Spy Handler', ->

  scrollSpyHandler = new glados.models.ScrollSpy.ScrollSpyHandler

  beforeEach -> scrollSpyHandler.resetSections()

  it 'initializes the structure', ->
    sections = scrollSpyHandler.get('sections')
    expect(_.isObject(sections)).toBe(true)

  it 'Registers a section', ->

    sectionName = 'Section1'
    scrollSpyHandler.registerSection(sectionName)
    sections = scrollSpyHandler.get('sections')

    expect(sections[sectionName].state).toBe(glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.NOT_AVAILABLE)
    expect(sections[sectionName].position).toBe(0)

  it 'Resets the sections', ->

    scrollSpyHandler.registerSection('a')
    scrollSpyHandler.registerSection('b')
    scrollSpyHandler.registerSection('c')
    scrollSpyHandler.registerSection('d')

    scrollSpyHandler.resetSections()

    sections = scrollSpyHandler.get('sections')
    expect(_.isObject(sections)).toBe(true)
    expect(_.keys(sections).length).toBe(0)

  it 'Registers sections in order', ->

    sectionNames = (i.toString() for i in [1..10])
    for name in sectionNames
      scrollSpyHandler.registerSection(name)

    sections = scrollSpyHandler.get('sections')
    for i in [0..sectionNames.length-1]
      currentName = sectionNames[i]
      expect(sections[currentName].state).toBe(glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.NOT_AVAILABLE)
      expect(sections[currentName].position).toBe(i)

  it 'Changes the state of a section to shown', ->

    sectionName = 'Section1'
    scrollSpyHandler.registerSection(sectionName)
    scrollSpyHandler.showSection(sectionName)
    sections = scrollSpyHandler.get('sections')

    expect(sections[sectionName].state).toBe(glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW)


