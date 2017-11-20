glados.useNameSpace 'glados.apps.Activity',
  ActivitiesBrowserApp: class ActivitiesBrowserApp

    @init = ->

      router = new glados.apps.Activity.ActivitiesRouter
      Backbone.history.start()

    @initBrowser = ->

      $mainContainer = $('.BCK-main-container')
      $mainContainer.show()
      filter = URLProcessor.getFilter()
      actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(filter)

      $browserContainer = $('.BCK-BrowserContainer')
      new glados.views.Browsers.BrowserMenuView
        collection: actsList
        el: $browserContainer

      actsList.fetch()

    @initMatrixFSView = (sourceEntity) ->

      $mainContainer = $('.BCK-main-container')
      $mainContainer.show()

      $('.BCK-main-container').children().hide()
      $('.BCK-main-container').find('.BCK-matrix-full-screen').show()
#      alert('FS: init matrix from ' + sourceEntity)



    @initMatrixCellMiniReportCard: ($containerElem, d, compoundsAreRows=true) ->

      summary = new glados.models.Activity.ActivityAggregation
        activity_count: d.activity_count
        pchembl_value_avg: d.pchembl_value_avg
        molecule_chembl_id: if compoundsAreRows then d.row_id else d.col_id
        target_chembl_id: if compoundsAreRows then d.col_id else d.row_id
        pchembl_value_max: d.pchembl_value_max

      new glados.views.Activity.ActivityAggregationView
        el: $containerElem
        model: summary