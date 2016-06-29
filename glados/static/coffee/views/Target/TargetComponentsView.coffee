# View that renders the Target Components section
# from the target report card
# load CardView first!
# also make sure the html can access the handlebars templates!
TargetComponentsView = CardView.extend

  initialize: ->
    @model.on 'change', @.render, @

  render: ->
    @render_for_large()
    @render_for_small()

  render_for_large: ->

    table_large = $(@el).find('#BCK-Components-large')
    template = $('#' + table_large.attr('data-hb-template'))
    table_large.html Handlebars.compile(template.html())
      components: @model.get('target_components')

  render_for_small: ->

    table_large = $(@el).find('#BCK-Components-small')
    template = $('#' + table_large.attr('data-hb-template'))
    table_large.html Handlebars.compile(template.html())
      components: @model.get('target_components')