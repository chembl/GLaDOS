glados.useNameSpace 'glados.views.SearchResults',
  StructureQueryView: Backbone.View.extend

    events:
      'click .BCK-Edit-Query': 'showEditModal'

    initialize: ->
      @queryParams = arguments[0].query_params
      @render()

    render: ->
      glados.Utils.fillContentForElement $(@el),
        search_term: @queryParams.search_term
        similarity: @queryParams.similarity_percentage

    showEditModal: (event) ->
      $clickedElem = $(event.currentTarget)
      $modal = ButtonsHelper.generateModalFromTemplate($clickedElem, 'Handlebars-Common-MarvinModal')

      if $modal.attr('data-marvin-initialised') != 'yes'
        new MarvinSketcherView
          el: $modal
          smiles_to_load_on_ready: @queryParams.search_term
          custom_initial_similarity: @queryParams.similarity_percentage
