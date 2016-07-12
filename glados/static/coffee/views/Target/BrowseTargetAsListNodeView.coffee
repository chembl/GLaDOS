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

    @model.verifyMyAncestryIsComplete()

  changed: ->

    if @model.get('selected') == true
      $(@el).find('[type="checkbox"]').prop('checked', true)
    else
      $(@el).find('[type="checkbox"]').prop('checked', false)

    # Visually, when it is incomplete it is also checked, NOT in the model!!!
    if @model.get('incomplete') == true
      $(@el).find('[type="checkbox"]').addClass('incomplete')
      $(@el).find('[type="checkbox"]').prop('checked', true)
    else
      $(@el).find('[type="checkbox"]').removeClass('incomplete')


