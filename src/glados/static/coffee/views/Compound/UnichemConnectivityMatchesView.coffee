glados.useNameSpace 'glados.views.Compound',
  UnichemConnectivityMatchesView: CardView.extend

    initialize: ->

      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @render, @
      @model.on 'error', @showCompoundErrorCard, @
      @resource_type = 'Compound'
      @collectionFetched = false

      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()

    events:
      'click .BCK-ToggleAlternateForms': 'toogleAlternateForms'

    render: ->

      thereAreNoReferences = not @model.get('_metadata').unichem?
      if thereAreNoReferences
        @hideSection()
        return

      inchiKey = @model.get('molecule_structures').standard_inchi_key
      if not @collection?
        @collection = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewUnichemConnectivityList()
        @collection.setInchiKey(inchiKey)
        @collection.on 'reset',  @render, @

      @renderDescription()

      $legendContainer = $(@el).find('.BCK-LegendContainer')
      glados.Utils.fillContentForElement($legendContainer)
      $includeSaltsButtonContainer = $(@el).find('.BCK-LoadAlternativeSaltsButtonContainer')
      glados.Utils.fillContentForElement $includeSaltsButtonContainer,
        include: @collection.isShowingAlternativeForms()
        disabled: @collection.thereAreNoAlternateFormsToShow()

      if @collection.thereAreNoAlternateFormsToShow()
        $toggleAltFormsBtn = $includeSaltsButtonContainer.find('.BCK-ToggleAlternateForms')

        $qtipContent = $('<div>There is no additional information from alternative salts and mixtures to show.</div>')
        qtipConfig =
            content:
              text: $qtipContent
            style:
              classes:'matrix-qtip qtip-light qtip-shadow'
            position: glados.Utils.Tooltips.getQltipSafePostion($toggleAltFormsBtn, $qtipContent)

        $toggleAltFormsBtn.qtip qtipConfig

      if @collection.isShowingAlternativeForms()
        @renderColoursLegend()
      else
        @hideColoursLegend()

      $restServiceCallContainer = $(@el).find('.BCK-RESTServiceCallContainer')
      glados.Utils.fillContentForElement $restServiceCallContainer,
        url: @collection.getUnichemURL().replace(/\?callback.*$/g, '')

      if not @tableView?
        @tableView = glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
          @collection, $(@el).find('.BCK-MatchesTable'), customRenderEvent=undefined, disableColumnsSelection=true)

      if not @collectionFetched
        @collection.fetch()
        @collectionFetched = true

      @showSection()
      @showCardContent()

    #-------------------------------------------------------------------------------------------------------------------
    # Description
    #-------------------------------------------------------------------------------------------------------------------
    renderDescription: ->

      inchiKey = @model.get('molecule_structures').standard_inchi_key
      standardInchi = @model.get('molecule_structures').standard_inchi

      $descriptionContainer = $(@el).find('.BCK-DescriptionContainer')
      glados.Utils.fillContentForElement $descriptionContainer,
        inchi_key: inchiKey
        standard_inchi: standardInchi

      $inchiKeyContainer = $descriptionContainer.find('.BCK-InchiKeyContainer')

      config =
        value: inchiKey
        download:
          filename: "#{@model.get('molecule_chembl_id')}-INCHI_Key.txt"
          value: inchiKey

      ButtonsHelper.initCroppedContainer($inchiKeyContainer, config)


    #-------------------------------------------------------------------------------------------------------------------
    # Colours Legend
    #-------------------------------------------------------------------------------------------------------------------
    renderColoursLegend: ->

      $container = $(@el).find('.BCK-ColoursLegendContainer')
      glados.Utils.fillContentForElement($container)
      @showColoursLegend()

    showColoursLegend: -> $(@el).find('.BCK-ColoursLegendContainer').show()
    hideColoursLegend: -> $(@el).find('.BCK-ColoursLegendContainer').hide()

    toogleAlternateForms: (event) ->

      $clickedElem = $(event.currentTarget)
      if $clickedElem.hasClass('disabled')
        return

      @tableView.resetPageNumber()
      @collection.toggleAlternativeSaltsAndMixtures()