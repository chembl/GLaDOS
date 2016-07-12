BrowseTargetAsListNodeView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @changed, @

  events:
   'click [type="checkbox"]': 'clickInput'


  clickInput: ->

    if @model.get('selected') == true
      @model.unCheckMeAndMyDescendants()
    else
      @model.checkMeAndMyDescendants()


  changed: ->

    if @model.get('selected') == true
      $(@el).find('[type="checkbox"]').prop('checked', true)
    else
      $(@el).find('[type="checkbox"]').prop('checked', false)


