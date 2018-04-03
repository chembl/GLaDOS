glados.useNameSpace 'glados.views.ScrollSpy',
  ScrollSpyView: Backbone.View.extend

    initialize: ->

      @model.on 'change:sections', @render, @
      $('.scrollspy').scrollSpy()

    render: ->
      sections = (s for s in _.values(@model.get('sections')) \
      when s.state == glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW).sort (a, b) ->
        return a.position - b.position

      @hidePreloader()
      $contentContainer = $(@el).find('.BCK-ScrollSpyContent')
      glados.Utils.fillContentForElement $contentContainer,
        sections: sections

    hidePreloader: ->
      $(@el).find('.BKC-preolader-to-hide').hide()

glados.models.ScrollSpy.ScrollSpyView.STATE =
  INITIAL: 'INITIAL'
  WAITING_DECISION: 'WAITING DECISION'
  SHOWING: 'SHOWING'