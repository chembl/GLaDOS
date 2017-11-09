glados.useNameSpace 'glados.views.ScrollSpy',
  ScrollSpyView: Backbone.View.extend

    initialize: ->

      @model.on 'change:sections', @render, @

    render: ->

      sections = (s for s in _.values(@model.get('sections')) \
      when s.state == glados.models.ScrollSpy.ScrollSpyHandler.SECTION_STATES.SHOW).sort (a, b) ->
        return a.position - b.position

      console.log 'AAA sections: ', sections
      console.log 'AAA all sections', @model.get('sections')

