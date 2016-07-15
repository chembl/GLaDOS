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

  changed: ->

    console.log('changed!' + @model.get('name'))
    if @model.get('selected')
      $(@el).find('[type="checkbox"]').prop('checked', true)
    else
      $(@el).find('[type="checkbox"]').prop('checked', false)

    # Visually, when it is incomplete it is also checked, NOT in the model!!!
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


    if @model.get('show')
      $(@el).show()
    else
      $(@el).hide()

  toggleCollapsed: ->

    @model.toggleCollapsed()





