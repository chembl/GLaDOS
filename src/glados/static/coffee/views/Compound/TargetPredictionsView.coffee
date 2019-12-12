glados.useNameSpace 'glados.views.Compound',
  TargetPredictionsView: CardView.extend

    initialize: ->
      CardView.prototype.initialize.call(@, arguments)
      @model.on 'change', @.render, @
      @model.on 'error', @.showCompoundErrorCard, @
      @resource_type = 'Compound'

      sortByFunc = (item) -> -parseFloat(item.probability)
      settings = glados.models.paginatedCollections.Settings.CLIENT_SIDE_WS_COLLECTIONS.TARGET_PREDICTIONS
      filterFunc1uM = (p) -> p.value == 1

      generator1uM =
        model: @model
        generator_property: '_metadata.target_predictions'
        filter: filterFunc1uM
        sort_by_function: sortByFunc

      @predictionList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewClientSideCollectionFor(settings,
        generator1uM)

      glados.views.PaginatedViews.PaginatedViewFactory.getNewTablePaginatedView(
        @predictionList, $(@el).find('.BCK-Predictions-Table'), customRenderEvent = undefined, disableColumnsSelection = true)

      @predictionList.once 'reset', @loadListWithMockData, @

      @initEmbedModal(arguments[0].embed_section_name, arguments[0].embed_identifier)
      @activateModals()


    render: ->

      rawTargetPredidctions = @model.get('_metadata').target_predictions
      if not rawTargetPredidctions?
        @hideSection()
        return
      if rawTargetPredidctions.length == 0
        @hideSection()
        return

      $chemblIDSpan = $(@el).find('.BCK-Predictions-MolChemblID')
      $chemblIDSpan.text(@model.get('id'))

      @showCardContent()
      @showSection()

# ------------------------------------------------------------------------------------------------------------------
# Mock Data
# ------------------------------------------------------------------------------------------------------------------
    loadListWithMockData: ->

      mockModels = []
      for mockDatum in @mockData
        mockPred = new glados.models.Compound.TargetPrediction(
          glados.models.Compound.TargetPrediction.prototype.parse(mockDatum)
        )
        mockModels.push(mockPred)

      @predictionList.reset(mockModels)


    mockData: [
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2581",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2778",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL264",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3202",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4685",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4018",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2782",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3650",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4481",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5137",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1904",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL255",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL299",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4224",
        "confidence_70": "inactive",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4016",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4029",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL252",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2095172",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL206",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1957",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3267",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL239",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3869",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1907598",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2722",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2111367",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL237",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1966",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4625",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5393",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL208",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4073",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1907591",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1995",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL230",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5704",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4080",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2145",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4641",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL298",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5555",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL253",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1902",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5932",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL402",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL254",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1792",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3667",
        "confidence_70": "uncertain",
        "confidence_80": "active",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL262",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2069161",
        "confidence_70": "active",
        "confidence_80": "active",
        "confidence_90": "active",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL6120",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4683",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3009",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4822",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL231",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1994",
        "confidence_70": "active",
        "confidence_80": "active",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4247",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1908389",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4081",
        "confidence_70": "inactive",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3892",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3268",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL236",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4429",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2527",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4072",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL209",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2095189",
        "confidence_70": "active",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1907599",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1951",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4282",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4878",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3437",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2971",
        "confidence_70": "uncertain",
        "confidence_80": "active",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4427",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL238",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4793",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2000",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4303",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5028",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2803",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3589",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "active",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1824",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3119",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL5480",
        "confidence_70": "active",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4304",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2007",
        "confidence_70": "inactive",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4794",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3922",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2094120",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4599",
        "confidence_70": "active",
        "confidence_80": "active",
        "confidence_90": "active",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3587",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2203",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL344",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL3746",
        "confidence_70": "active",
        "confidence_80": "active",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2835",
        "confidence_70": "active",
        "confidence_80": "active",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL2439",
        "confidence_70": "uncertain",
        "confidence_80": "uncertain",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4198",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4508",
        "confidence_70": "uncertain",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL1075317",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "uncertain",
        "in_training": "yes"
      },
      {
        "empty": "0",
        "molecule_chembl_id": "CHEMBL3894860",
        "target_chembl_id": "CHEMBL4361",
        "confidence_70": "inactive",
        "confidence_80": "inactive",
        "confidence_90": "inactive",
        "in_training": "yes"
      }
    ]