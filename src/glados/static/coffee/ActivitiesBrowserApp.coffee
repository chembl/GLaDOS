class ActivitiesBrowserApp

  @init = ->

    filter = URLProcessor.getFilter()
    actsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewESActivitiesList(filter)

    new glados.views.Browsers.BrowserMenuView
      collection: actsList
      el: $('.BCK-BrowserContainer')
      standalone_mode: true

    new glados.views.Browsers.BrowserFacetView
      collection: actsList
      standalone_mode: true

    actsList.fetch()

  @initMatrixCellMiniReportCard: ($containerElem, d) ->

    summary = new glados.models.Activity.ActivityAggregation
      activity_count: d.activity_count
      pchembl_value_avg: d.pchembl_value_avg

    new glados.views.Activity.ActivityAggregationView
      el: $containerElem
      model: summary