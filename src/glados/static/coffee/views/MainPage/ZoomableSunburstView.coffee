glados.useNameSpace 'glados.views.MainPage',
  ZoomableSunburstView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      console.log 'IM THE ZOOMABLE SUNBURST VIEW :)'
      @$vis_elem = $(@el).find('.BCK-sunburst-container')
      @setUpResponsiveRender()
      @model.on 'change', @render, @

    render: ->

      thisView = @

      if @model.get('state') == glados.models.Aggregations.Aggregation.States.NO_DATA_FOUND_STATE
        return

      if @model.get('state') == glados.models.Aggregations.Aggregation.States.LOADING_BUCKETS
        return

      if @model.get('state') != glados.models.Aggregations.Aggregation.States.INITIAL_STATE
        return

      @showCardContent()
      @$vis_elem.empty()

      @ROOT = @getBucketData()
      @VISUALISATION_WIDTH = $(@el).width()
      @VISUALISATION_HEIGHT = @VISUALISATION_WIDTH

    getBucketData: ->
      receivedBuckets = @model.get 'bucket_data'
      id = 0

      fillNode = (parent_node, input_node) ->

        node = {}
        node.name = input_node.key
        node.size = input_node.doc_count
        node.parent_id = parent_node.id
        node.id = id
        node.link = input_node.link
        node.depth = parent_node.depth + 1
        node.parent = parent_node

        parent_node.children.push(node)

        if input_node.children?
          node.children = []
          for child in input_node.children['buckets']
            id++
            fillNode(node, child)

      if receivedBuckets?
        root = {}
        root.depth = 0
        root.name = 'root'
        root.id = id

        if receivedBuckets.children?
          root.children = []
          for node in receivedBuckets.children['buckets']
            id++
            fillNode(root, node)

      return root


    showCardContent: ->
      $(@el).find('.card-preolader-to-hide').hide()
      $(@el).find('.card-content').show()

