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

      visualisationsConfig = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG
      numSlides = _.keys(visualisationsConfig).length
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
        infinite: false
      }

      $captionsCarousel.slick {
        useCSS: false
        fade: true
        arrows: false
        dots: false
        initialSlide: initialSlide
        infinite: false
      }

      thisView = @
      $carouselContainer.on 'setPosition', (event, slick) -> thisView.initSlide(slick.currentSlide)
      @initSlide(initialSlide)

    initSlide: (slideNumber) ->

      console.log 'init slide: ', slideNumber
      $vizContainers = $(@el).find("[data-carousel-item-id='CarouselVisualisation#{slideNumber}']")
      $captionContainers = $(@el).find("[data-carousel-item-id='CarouselCaption#{slideNumber}']")

      wasInitialised = $vizContainers.attr('data-initialised')
      console.log 'was initialised: ', wasInitialised

      if wasInitialised != 'yes'

        visualisationConfig = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG[slideNumber]
        console.log 'visualisationConfig: ', visualisationConfig
        templateSourceURL = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_HB_SOURCES
        templateID = visualisationConfig.template_id
        caption = visualisationConfig.caption
        console.log 'templateID: ', templateID
        loadPromise = glados.Utils.loadTemplateAndFillContentForElement(templateSourceURL, templateID, $vizContainers)

        loadPromise.fail (msg) ->
          throw msg

        loadPromise.done ->
          console.log 'going to execute load function'
          initFunction = visualisationConfig.init_function
          initFunction()

        templateParams =
          caption: caption
        glados.Utils.fillContentForElement($captionContainers, templateParams, 'Handlebars-Carousel-items-caption')

        $vizContainers.attr('data-initialised', 'yes')

glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_HB_SOURCES =
  "#{glados.Settings.GLADOS_BASE_PATH_REL}handlebars/visualisation_sources"

glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG =
  0:
    caption: 'Caption For 0'
    template_id: 'Handlebars-Visualisations-BrowseEntitiesCircles'
    init_function: MainPageApp.initBrowseEntities
  1:
    caption: 'Caption For 1'
    template_id: 'Handlebars-Visualisations-ZoomableSunburst'
    init_function: MainPageApp.initZoomableSunburst
  2:
    caption: 'Caption For 2'
    template_id: 'Handlebars-Visualisations-DrugsPerUsanYear'
    init_function: MainPageApp.initDrugsPerUsanYear
  3:
    caption: 'Caption For 3'
    template_id: 'Handlebars-Visualisations-BrowseTargetsAsCircles'
    init_function: MainPageApp.initTargetsVisualisation
  4:
    caption: 'Caption For 4'
    template_id: 'Handlebars-Visualisations-MaxPhaseForDiseaseDonut'
    init_function: MainPageApp.initMaxPhaseForDisease
  5:
    caption: 'Caption For 5'
    template_id: 'Handlebars-Visualisations-DrugFirstApprovalHistogram'
    init_function: MainPageApp.initFirstApprovalByMoleculeType