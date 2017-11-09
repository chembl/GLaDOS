glados.useNameSpace 'glados.models.ScrollSpy',
  ScrollSpyHandler: Backbone.Model.extend

    initialize: -> @set('sections', {})

    registerSection: (sectionName) ->
      sections = @get('sections')
      sections[sectionName] =
        state: glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.NOT_AVAILABLE
        position: _.keys(sections).length
      @set('sections', sections)

    showSection: (sectionName) ->
      sections = @get('sections')
      sections[sectionName].state = glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW
      @set('sections', sections)

    resetSections: ->
      @set('sections', {})

glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES =
  NOT_AVAILABLE: 'NOT_AVAILABLE'
  SHOW: 'SHOW'