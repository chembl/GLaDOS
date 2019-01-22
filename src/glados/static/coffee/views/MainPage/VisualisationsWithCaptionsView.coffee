glados.useNameSpace 'glados.views.MainPage',
  VisualisationsWithCaptionsView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->

      @views = {}
      @carouselInitialised = false
      @setUpResponsiveRender(emptyBeforeRender=false)
      @render()

    hidePreloader: ->
    showPreloader: ->

    render: ->

      if glados.getScreenType() != glados.Settings.SMALL_SCREEN
        if not @carouselInitialised
          @initCarousel()

    initCarousel: ->

      $carouselContainer = $(@el).find('.BCK-carousel-wrapper')
      $captionsCarousel = $(@el).find('.BCK-carousel-captions')

      visualisationsConfig = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG
      numSlides = _.keys(visualisationsConfig).length
      initialSlide = Math.floor(Math.random() * numSlides)

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
      @carouselInitialised = true

    initSlide: (slideNumber) ->

      $vizContainer = $(@el).find("[data-carousel-item-id='CarouselVisualisation#{slideNumber}']")
      $captionContainer = $(@el).find("[data-carousel-item-id='CarouselCaption#{slideNumber}']")

      wasInitialised = $vizContainer.attr('data-initialised')

      if wasInitialised != 'yes' or @IS_RESPONSIVE_RENDER

        visualisationConfig = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG[slideNumber]

        description = visualisationConfig.description
        instructions = visualisationConfig.instructions
        linkTitle = visualisationConfig.link_title
        LinkFunction = visualisationConfig.link_url_function
        visTitle = visualisationConfig.vis_title

        templateParams =
          description: description
          instructions: instructions
          link_title: linkTitle
          link_url: LinkFunction()
          vis_title: visTitle
          vis_id: slideNumber
        glados.Utils.fillContentForElement($captionContainer, templateParams, 'Handlebars-Carousel-items-caption')

        templateSourceURL = glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_HB_SOURCES
        templateID = visualisationConfig.template_id
        loadPromise = glados.Utils.loadTemplateAndFillContentForElement(templateSourceURL, templateID, $vizContainer)

        thisView = @
        loadPromise.done ->
          initFunction = visualisationConfig.init_function
          if visualisationConfig.uses_browse_button_dynamically
            $browseButtonContainer =
              $(thisView.el).find(".BCK-browse-button[data-viz-item-id='Visualisation#{slideNumber}']")
            thisView.views[slideNumber] = initFunction($browseButtonContainer)
          else
            thisView.views[slideNumber] = initFunction()

        $vizContainer.attr('data-initialised', 'yes')

glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_HB_SOURCES =
  "#{glados.Settings.GLADOS_BASE_PATH_REL}handlebars/visualisation_sources"

glados.views.MainPage.VisualisationsWithCaptionsView.VISUALISATIONS_CONFIG =
  0:
    description: 'Shows a summary of the ChEMBL entities and quantities of data for each of them.'
    instructions: 'Click on a bubble to explore a specific ChEMBL entity in more detail.'
    template_id: 'Handlebars-Visualisations-BrowseEntitiesCircles'
    init_function: MainPageApp.initBrowseEntities
    link_title: 'Browse all ChEMBL'
    link_url_function: -> SearchModel.getSearchURL()
    vis_title: 'Explore ChEMBL'
  1:
    description: 'Representation of the ChEMBL protein target classification hierarchy.'
    instructions: 'Click on a section to expand it and then click on the browse button to start exploring the target family in more detail.'
    template_id: 'Handlebars-Visualisations-ZoomableSunburst'
    init_function: MainPageApp.initZoomableSunburst
    link_title: 'Browse all Targets'
    link_url_function: -> Target.getTargetsListURL()
    vis_title: 'Protein Targets in ChEMBL'
    uses_browse_button_dynamically: true
  2:
    description: 'Bar chart showing the current maximum development phase for compounds and the year they were registered with a USAN (United States Adopted Name). Note: only shows compounds with a known USAN registration year.'
    instructions: 'Click on a bar to explore the drugs\' details.'
    template_id: 'Handlebars-Visualisations-DrugsPerUsanYear'
    init_function: MainPageApp.initDrugsPerUsanYear
    link_title: 'Browse all USAN Drugs'
    link_url_function: -> Drug.getDrugsListURL('_metadata.compound_records.src_id:13')
    vis_title: 'Development Phase and USAN Registration'
  3:
    description: 'Representation of the taxonomy hierarchy used to classify the ChEMBL organisms.'
    instructions: 'Click on a bubble to focus on a taxonomy class and then click on the browse button to start exploring the taxonomy class in more detail.'
    template_id: 'Handlebars-Visualisations-BrowseTargetsAsCircles'
    init_function: MainPageApp.initTargetsVisualisation
    link_title: 'Browse all Targets'
    link_url_function: -> Target.getTargetsListURL()
    vis_title: 'ChEMBL Taxonomy Tree'
    uses_browse_button_dynamically: true
  4:
    description: 'Distribution of drugs and clinical candidate development phases for the most frequent drug indications.  Note: less frequently occurring indications are not shown.'
    instructions: 'Click on a sector of the piechart to explore the compounds for that indication and development phase.'
    template_id: 'Handlebars-Visualisations-MaxPhaseForDiseaseDonut'
    init_function: MainPageApp.initMaxPhaseForDisease
    link_title: 'Browse all Drugs'
    link_url_function: -> Drug.getDrugsListURL()
    vis_title: 'ChEMBL Indications for Drugs'
  5:
    description: 'Bar chart showing the distribution of types of drugs (small molecules, antibodies etc) and the year they were approved for use.'
    instructions: 'Click on a bar to explore the drugs\' details.'
    template_id: 'Handlebars-Visualisations-DrugFirstApprovalHistogram'
    init_function: MainPageApp.initFirstApprovalByMoleculeType
    link_title: 'Browse all Approved Drugs'
    link_url_function: -> Drug.getDrugsListURL('_exists_:first_approval')
    vis_title: 'Drugs by Molecule Type and First Approval'