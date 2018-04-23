glados.useNameSpace 'glados.views.MainPage',
  AssociatedResourcesView: Backbone.View.extend

    initialize: ->
      @baseID = '.base'
      @render()

    render: ->
      @showItem(@baseID)

    events:
      'mouseover #ntd-link': -> @showItem('.ntd')
      'mouseover #sure-link': -> @showItem('.sure')
      'mouseover #uni-link': -> @showItem('.uni')

      'mouseout #ntd-link': -> @showItem(@baseID)
      'mouseout #sure-link': -> @showItem(@baseID)
      'mouseout #uni-link': -> @showItem(@baseID)

    showItem: (id) ->

      $contentElement = $(@el).find('.BCK-associated-resources-img')
      glados.Utils.fillContentForElement $contentElement

      if id != @baseID
        $contentElement.find(id).show()
        $contentElement.find(@baseID).hide()













