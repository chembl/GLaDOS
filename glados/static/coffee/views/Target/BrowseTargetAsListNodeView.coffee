BrowseTargetAsListNodeView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @changed, @

  events:
   'click [type="checkbox"]': 'clickInput'
   'click .tree-expander': 'toggleCollapsed'


  clickInput: ->

    if @model.get('selected') == true
      @model.unCheckMeAndMyDescendants()
    else
      @model.checkMeAndMyDescendants()

    @model.verifyMyAncestryIsComplete()

  changed: ->

    console.log('changed!' + @model.get('name'))
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

    if @model.get('show') == true
      $(@el).show()
    else
      $(@el).hide()

  toggleCollapsed: ->

    @model.toggleCollapsed()





