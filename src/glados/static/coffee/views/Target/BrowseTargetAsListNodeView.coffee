BrowseTargetAsListNodeView = Backbone.View.extend

  initialize: ->
    @model.on 'change', @changed, @
    @model.on TargetHierarchyNode.NODE_FOCUSED_EVT, @focused, @

  events:
   'click [type="checkbox"]': 'clickInput'
   'click .tree-expander': 'toggleCollapsed'
   'click .focus-on-leaf': 'toggleCollapsed'


  clickInput: ->

    @model.toggleSelection()

  changed: ->

    # handle change of a node from different perspectives

    if @model.get('selected')
      $(@el).find('[type="checkbox"]').prop('checked', true)
    else
      $(@el).find('[type="checkbox"]').prop('checked', false)

    # Visually, when it is incomplete it is also checked, NOT in the model!!!
    # this is a trick to make the checkbox be filled without a check
    if @model.get('incomplete')
      $(@el).find('[type="checkbox"]').addClass('incomplete')
      $(@el).find('[type="checkbox"]').prop('checked', true)
    else
      $(@el).find('[type="checkbox"]').removeClass('incomplete')


    if !@model.get('is_leaf')

      if @model.get('collapsed')
        $(@el).find('.tree-expander').removeClass('tree-expander-expanded')
        $(@el).find('.tree-expander').addClass('tree-expander-collapsed')
      else
        $(@el).find('.tree-expander').addClass('tree-expander-expanded')
        $(@el).find('.tree-expander').removeClass('tree-expander-collapsed')


    if @model.get('found')
      $(@el).addClass('green accent-1')
    else
      $(@el).removeClass('green accent-1')


    if @model.get('show')
      $(@el).show()
    else
      $(@el).hide()

    if @model.get('focused')
      $(@el).find('.node-being-focused').show()
    else
      $(@el).find('.node-being-focused').hide()


  toggleCollapsed: ->
    @model.toggleCollapsed()

  focused: ->
    @model.expandMyAncestors()






