glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search facet to filter results
  SearchFacetView: Backbone.View.extend

    initialize: () ->
      # @collection - must be provided in the constructor call
      @el = $('.collapsible.collapsible-accordion.side-nav')
      @collection.on 'reset do-repaint sort', @render, @

    toggleSelectFacet: (facet_key) ->
      console.log("HI!", facet_key)

    render: (collection)->
      # removes the non main menus of the sidebar
      if @collection
        facets = collection.getFacets()
        if facets
          for facet_key_i, facet_i of facets
            links_data = []
            faceting_handler_i = facet_i.faceting_handler
            facet_total = 0
            for key_i in faceting_handler_i.faceting_keys_inorder
              link_facet_i = {}
              link_facet_i.select_callback = @toggleSelectFacet.bind(@,key_i)
              link_facet_i.link_id = faceting_handler_i.getFacetId(key_i)
              link_facet_i.label = key_i
              link_facet_i.badge = faceting_handler_i.faceting_data[key_i]
              facet_total += faceting_handler_i.faceting_data[key_i]
              links_data.push(link_facet_i)
            menu_key = 'faceting_menu_'+facet_key_i
            if facet_total
              SideMenuHelper.addMenu(menu_key,
                {
                  title: facet_i.label
                  title_badge: facet_total
                  links: links_data
                }
              )
            else
              SideMenuHelper.removeMenu(menu_key)
          SideMenuHelper.renderMenus()