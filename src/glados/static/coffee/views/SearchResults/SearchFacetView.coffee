glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search facet to filter results
  SearchBarView: Backbone.View.extend

    el: $('.collapsible.collapsible-accordion.side-nav')
    initialize: () ->
      @handlebars_template = Handlebars.compile($('#Handlebars-SideBar-CollapsibleMenu').html())
      return

    renderFacets: (collection)->
      # removes the non main menus of the sidebar
      $(@el).not('.menu-logo').not('.navigation-menu').remove()
      if collection
        $(@el).find('.navigation-menu').find('.collapsible-header').removeClass('active')
        facets = collection.getFacets()

        for facet_key_i, facet_i of facets
          @handlebars_template(
            title: facet_i.label
          )
      else
        $(@el).find('.navigation-menu').find('.collapsible-header').addClass('active')