# Class in charge of rendering the index page of the ChEMBL web ui
class MainPageApp

  # --------------------------------------------------------------------------------------------------------------------
  # Initialization
  # --------------------------------------------------------------------------------------------------------------------

  @init = ->

    new glados.views.MainPage.CentralCardView
      el: $('.BCK-Central-Card')

    databaseInfo = new glados.models.MainPage.DatabaseSummaryInfo()
    console.log 'databaseInfo: ', databaseInfo
    new glados.views.MainPage.DatabaseSummaryView
      model: databaseInfo
      el: $('.BCK-Database-summary-info')

    databaseInfo.fetch()

    tweetsList = glados.models.paginatedCollections.PaginatedCollectionFactory.getNewTweetsList()
    tweetsList.initURL()
    $tweetsElem = $('.BCK-Tweets-container')
    glados.views.PaginatedViews.PaginatedViewFactory.getNewInfinitePaginatedView(tweetsList, $tweetsElem, 'do-repaint')

    tweetsList.fetch()

    MainPageApp.initPapersPerYear()

# ---------------- Aggregation -------------- #
  @getDocumentsPerYearAgg = (minCols=1, maxCols=40, defaultCols=40) ->

    queryConfig =
      type: glados.models.Aggregations.Aggregation.QueryTypes.QUERY_STRING
      query_string_template: '*'
      template_data: {}

    aggsConfig =
      aggs:
        x_axis_agg:
          field: 'year'
          type: glados.models.Aggregations.Aggregation.AggTypes.RANGE
          histogram: true
          min_columns: minCols
          max_columns: maxCols
          num_columns: defaultCols

    allDocumentsByYear = new glados.models.Aggregations.Aggregation
      index_url: glados.models.Aggregations.Aggregation.DOCUMENT_INDEX_URL
      query_config: queryConfig
      aggs_config: aggsConfig

    return allDocumentsByYear


  @initPapersPerYear = ->
    allDocumentsByYear = MainPageApp.getDocumentsPerYearAgg()

    histogramConfig =
      big_size: true
      paint_axes_selectors: true
      properties:
        count: glados.models.visualisation.PropertiesFactory.getPropertyConfigFor('DocumentAggregation', 'HIT_COUNT')
      initial_property_x: 'count'
      x_axis_options: ['count']
      x_axis_min_columns: 1
      x_axis_max_columns: 40
      x_axis_initial_num_columns: 40
      x_axis_prop_name: 'x_axis_agg'
      title: 'Documents by Year'
      range_categories: true

    new glados.views.Visualisation.HistogramView
      el: $('.BCK-MainHistogramContainer')
      config: histogramConfig
      model: allDocumentsByYear


    allDocumentsByYear.fetch()
