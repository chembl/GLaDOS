glados.useNameSpace 'glados.views.SearchResults',
  StructureQueryView: Backbone.View.extend

    events:
      'click .BCK-Edit-Query': 'showEditModal'

    initialize: ->
      @queryParams = arguments[0].query_params
      @render()

    render: ->
      glados.Utils.fillContentForElement $(@el),
        image_url: glados.Settings.BEAKER_BASE_URL + 'smiles2svg/'+ btoa(@queryParams.search_term)
        search_term: @queryParams.search_term
        similarity: @queryParams.similarity_percentage

    showEditModal: (event) ->
      @$clickedElem = $(event.currentTarget)
      if not @$modal?
        @$modal = ButtonsHelper.generateModalFromTemplate(@$clickedElem, 'Handlebars-Common-MarvinModal')

      if @$modal.attr('data-marvin-initialised') != 'yes'

        sketcherParams =
          el: @$modal
          custom_initial_similarity: @queryParams.similarity_percentage

        if @queryParams.search_term.startsWith('CHEMBL')
          sketcherParams.chembl_id_to_load_on_ready = @queryParams.search_term
        else
          sketcherParams.smiles_to_load_on_ready = @queryParams.search_term

        new MarvinSketcherView(sketcherParams)