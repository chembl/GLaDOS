glados.useNameSpace 'glados.apps.Browsers',
  BrowserApp: class BrowserApp

    @init =->

      router = new glados.apps.Browsers.BrowserRouter
      Backbone.history.start()

    @entityListsInitFunctions:
      compounds: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCompoundsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      targets: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTargetsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      assays: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESAssaysList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      documents: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDocumentsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      cells: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESCellsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      tissues: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESTissuesList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      drugs: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDrugsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      activities: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      mechanisms_of_action: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESMechanismsOfActionList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)
      drug_indications: glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESDrugIndicationsList\
        .bind(glados.models.paginatedCollections.PaginatedCollectionFactory)

    # TODO: standardise the entity names from the models
    @entityNames:
      compounds: 'Compounds'
      targets: 'Targets'
      assays: 'Assays'
      documents: 'Documents'
      cells: 'Cells'
      tissues: 'Tissues'
      drugs: 'Drugs'
      activities: 'Activities'
      mechanisms_of_action: 'Drug Mechanisms'
      drug_indications: 'Drug Indications'

    @initBrowserForEntity = (entityName, query, state, isFullState=false) ->

      $mainContainer = $('.BCK-main-container')
      $mainContainer.show()

      $browserWrapper = $mainContainer.find('.BCK-browser-wrapper')
      glados.Utils.fillContentForElement $browserWrapper,
        entity_name: @entityNames[entityName]

      $browserWrapper.show()
      #this is temporary, while we figure out how handle the states
      # -----------------learn to handle the state!----------------
      $matrixFSContainer = $mainContainer.find('.BCK-matrix-full-screen')
      if state?
        if state.startsWith('matrix_fs_')
          sourceEntity = state.split('matrix_fs_')[1]

          $browserWrapper.children().hide()
          $matrixFSContainer.show()

          if sourceEntity == 'Targets'
            filterProperty = 'target_chembl_id'
            aggList = ['target_chembl_id', 'molecule_chembl_id']
          else
            filterProperty = 'molecule_chembl_id'
            aggList = ['molecule_chembl_id', 'target_chembl_id']

          ctm = new glados.models.Activity.ActivityAggregationMatrix
            query_string: query
            filter_property: filterProperty
            aggregations: aggList

          config = MatrixView.getDefaultConfig sourceEntity

          $matrixContainer = $matrixFSContainer.find('.BCK-CompTargetMatrix')
          new MatrixView
            model: ctm
            el: $matrixContainer
            config: config

          ctm.fetch()

          return
      $matrixFSContainer.hide()
      # -----------------learn to handle the state!----------------

      if state? and isFullState
        decodedState = JSON.parse(atob(state))
        listState = decodedState.list
        list = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESResultsListFromState(listState)
      else
        initListFunction = @entityListsInitFunctions[entityName]
        list = initListFunction(query)

      glados.helpers.URLHelper.getInstance().listenToList(list)
      $browserContainer = $browserWrapper.find('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: list
        el: $browserContainer

      list.fetch()

