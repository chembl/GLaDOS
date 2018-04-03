glados.useNameSpace 'glados.views.ScrollSpy',
  ScrollSpyView: Backbone.View.extend

    initialize: ->
      @scrollSpyState = glados.views.ScrollSpy.ScrollSpyView.STATE.INITIAL
      @model.on 'change:sections', @render, @


    render: ->
      sections =  _.values(@model.get('sections'))
      waiting = false

      if @scrollSpyState == glados.views.ScrollSpy.ScrollSpyView.STATE.INITIAL
        console.log 'scrollSpyState:  ', @scrollSpyState

        for s, i in sections
          @scrollSpyState = glados.views.ScrollSpy.ScrollSpyView.STATE.WAITING_DECISION if s.decided_state == true

      else if @scrollSpyState == glados.views.ScrollSpy.ScrollSpyView.STATE.WAITING_DECISION
        console.log 'scrollSpyState:  ', @scrollSpyState

        sections =  _.values(@model.get('sections'))
        for s, i in sections
          waiting = true if s.decided_state == false

        @scrollSpyState = glados.views.ScrollSpy.ScrollSpyView.STATE.SHOWING if waiting == false

      if @scrollSpyState == glados.views.ScrollSpy.ScrollSpyView.STATE.SHOWING
        console.log 'scrollSpyState:  ', @scrollSpyState
        $('.scrollspy').scrollSpy()
        sections = (s for s in _.values(@model.get('sections')) \
        when s.state == glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW).sort (a, b) ->
          return a.position - b.position

        @hidePreloader()
        $contentContainer = $(@el).find('.BCK-ScrollSpyContent')
        glados.Utils.fillContentForElement $contentContainer,
          sections: sections

    hidePreloader: ->
      $(@el).find('.BKC-preolader-to-hide').hide()

glados.views.ScrollSpy.ScrollSpyView.STATE =
  INITIAL: 'INITIAL'
  WAITING_DECISION: 'WAITING DECISION'
  SHOWING: 'SHOWING'