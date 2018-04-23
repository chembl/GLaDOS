glados.useNameSpace 'glados.views.MainPage',
  AssociatedResourcesView: Backbone.View.extend

    initialize: ->
      console.log 'im the associated resources view !!!!'
      @render()

    render: ->
      console.log 'I will render chembl associated resources :)'
      #      $defaultImageToShow = $(@el).find('#base-img')
      #      @showItem($defaultImageToShow)

      $contentElement = $(@el).find('.BCK-associated-resources-img')
      glados.Utils.fillContentForElement $contentElement,
        img_url: 'img/icons/res_img/base.png'

    events:
      'mouseover #ntd-link': "showItem"
      'mouseover #sure-link': "showItem"
      'mouseover #uni-link': "showItem"

    showItem: (event) ->
      console.log 'Element: ', event.target.id











