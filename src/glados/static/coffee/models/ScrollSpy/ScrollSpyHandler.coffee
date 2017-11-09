glados.useNameSpace 'glados.models.ScrollSpy',
  ScrollSpyHandler: Backbone.Model.extend

    initialize: -> @set('sections', {})

    registerSection: (sectionName) ->
      sections = @get('sections')
      sections[sectionName] =
        name: sectionName
        state: glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.NOT_AVAILABLE
        position: _.keys(sections).length
      @trigger('change:sections')

    showSection: (sectionName) ->
      sections = @get('sections')
      sections[sectionName].state = glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW
      @trigger('change:sections')


    resetSections: ->
      @set('sections', {})

glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES =
  NOT_AVAILABLE: 'NOT_AVAILABLE'
  SHOW: 'SHOW'