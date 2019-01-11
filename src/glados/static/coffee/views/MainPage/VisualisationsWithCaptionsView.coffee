glados.useNameSpace 'glados.views.MainPage',
  VisualisationsWithCaptionsView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->

      @carouselInitialised = false
      @setUpResponsiveRender()
      @render()

    render: ->

      if glados.getScreenType() != glados.Settings.SMALL_SCREEN

        if not @carouselInitialised

          @initCarousel()
          @carouselInitialised = true

    initCarousel: ->

      $carouselContainer = $(@el).find('.BCK-carousel-wrapper')
      $captionsCarousel = $(@el).find('.BCK-carousel-captions')

      numSlides = 2
      initialSlide = Math.floor(Math.random() * numSlides)
      console.log 'initialSlide: ', initialSlide


      glados.Utils.fillContentForElement $carouselContainer,
        visualisations_ids: ({id:i, is_caption: false} for i in [0..numSlides-1])

      glados.Utils.fillContentForElement $captionsCarousel,
        visualisations_ids: ({id:i, is_caption: true} for i in [0..numSlides-1])

      $carouselContainer.slick {
        asNavFor: $captionsCarousel
        arrows: true
        dots: true
        initialSlide: initialSlide
      }

      $captionsCarousel.slick {
        useCSS: false
        fade: true
        arrows: false
        dots: false
        initialSlide: initialSlide
      }

      thisView = @
      $carouselContainer.on 'setPosition', (event, slick) -> thisView.initSlide(slick.currentSlide)
      @initSlide(initialSlide)

    initSlide: (slideNumber) ->

      console.log 'init slide: ', slideNumber
      $containers = $(@el).find("[data-carousel-item-id='CarouselVisualisation#{slideNumber}']")
      wasInitialised = $containers.attr('data-initialised')
      console.log 'was initialised: ', wasInitialised

      if wasInitialised != 'yes'

        $containers.attr('data-initialised', 'yes')
        console.log 'doing init process'



