glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search facet to filter results
  SearchFacetView: Backbone.View.extend

    initialize: () ->
      # @collection - must be provided in the constructor call
      # @search_bar_view - must be provided in the constructor call
      @el = $('.collapsible.collapsible-accordion.side-nav')
      @collection.on 'reset do-repaint sort', @render, @

    toggleSelectFacet: (facet_group_key, facet_key) ->
      facets_groups = @collection.getFacetsGroups()
      faceting_handler = facets_groups[facet_group_key].faceting_handler
      faceting_handler.toggleKeySelection(facet_key)

      menu_key = @getMenuKey(facet_group_key)
      SideMenuHelper.updateSelectedLink(
        menu_key,
        faceting_handler.getFacetId(facet_key),
        faceting_handler.faceting_data[facet_key].selected
      )
      @collection.setMeta('facets_filtered', true)
      @collection.fetch()

    getMenuKey:(facet_group_key)->
      return 'faceting_menu_'+facet_group_key

    render: (collection)->
      # removes the non main menus of the sidebar
      if @collection
        facets_groups = collection.getFacetsGroups()
        if facets_groups
          for facet_group_key, facet_group of facets_groups
            links_data = []
            faceting_handler_i = facet_group.faceting_handler
            facet_total = 0
            for facet_key in faceting_handler_i.faceting_keys_inorder
              link_facet_i = {}
              link_facet_i.select_callback = @toggleSelectFacet.bind(@, facet_group_key, facet_key)
              link_facet_i.link_class_key = faceting_handler_i.getFacetId(facet_key)
              link_facet_i.label = facet_key
              link_facet_i.selected = faceting_handler_i.faceting_data[facet_key].selected
              link_facet_i.badge = faceting_handler_i.faceting_data[facet_key].count
              facet_total += faceting_handler_i.faceting_data[facet_key].count
              links_data.push(link_facet_i)
            menu_key = @getMenuKey(facet_group_key)
            if facet_total
              SideMenuHelper.addMenu(menu_key,
                {
                  title: facet_group.label
                  title_badge: facet_total
                  links: links_data
                }
              )
            else
              SideMenuHelper.removeMenu(menu_key)
          SideMenuHelper.renderMenus()