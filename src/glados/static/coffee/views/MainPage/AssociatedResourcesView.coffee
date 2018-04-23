glados.useNameSpace 'glados.views.MainPage',
  AssociatedResourcesView: Backbone.View.extend

    initialize: ->
      console.log 'im the associated resources view !!!!'
      @baseImgUrl = 'base.png'
      @render()

    render: ->
      console.log 'I will render chembl associated resources :)'
      @showItem(@baseImgUrl)

    events:
      'mouseover #ntd-link': -> @showItem('ntd.png')
      'mouseover #sure-link': -> @showItem('sure.png')
      'mouseover #uni-link': -> @showItem('uni.png')

      'mouseout #ntd-link': -> @showItem(@baseImgUrl)
      'mouseout #sure-link': -> @showItem(@baseImgUrl)
      'mouseout #uni-link': -> @showItem(@baseImgUrl)

    showItem: (imgUrl) ->
      console.log 'element',imgUrl
      imgName = imgUrl

      $contentElement = $(@el).find('.BCK-associated-resources-img')
      glados.Utils.fillContentForElement $contentElement,
        img_url: glados.Settings.STATIC_IMAGES_URL + 'icons/res_img/' + imgName













