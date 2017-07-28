glados.useNameSpace 'glados.views.Browsers',
  # View that renders the search facet to filter results
  BrowserFacetView: Backbone.View.extend(ResponsiviseViewExt).extend

    initialize: ->
      console.log 'init BrowserFacetView'
      @$vis_elem = $(@el)
      @setUpResponsiveRender()
      @collection.on 'facets-changed', @render, @

    render: ->
      facetsGroups = @collection.getFacetsGroups()

      facetListForRender = []
      for key, fGroup of facetsGroups
        facetListForRender.push
          label: fGroup.label
          key: key

      glados.Utils.fillContentForElement $(@el),
        facets: facetListForRender

      @paintAllHistograms()

    paintAllHistograms: ->
      $histogramsContainers = $(@el).find('.BCK-facet-group-histogram')
      thisView = @
      $histogramsContainers.each((i) -> thisView.paintHistogram($(@)))

    paintHistogram: ($containerElem) ->

      console.log 'painting histogram in: ', $containerElem




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
      @collection.setMeta('facets_changed', true)
      @collection.fetch()

    getMenuKey:(facet_group_key)->
      return 'faceting_menu_'+facet_group_key


#    render: ->
#      facets_groups = @collection.getFacetsGroups()
#      if facets_groups
#        for facet_group_key, facet_group of facets_groups
#          links_data = []
#          faceting_handler_i = facet_group.faceting_handler
#          faceting_handler_id = faceting_handler_i.getFacetingHandlerId()
#          menu_key = @getMenuKey(faceting_handler_id)
#          SideMenuHelper.removeMenu(menu_key)
#          facet_total = 0
#          if faceting_handler_i.faceting_keys_inorder
#            for facet_key in faceting_handler_i.faceting_keys_inorder
#              link_facet_i = {}
#              link_facet_i.select_callback = @toggleSelectFacet.bind(@, facet_group_key, facet_key)
#              link_facet_i.link_class_key = faceting_handler_i.getFacetId(facet_key)
#              link_facet_i.label = facet_key
#              link_facet_i.selected = faceting_handler_i.faceting_data[facet_key].selected
#              link_facet_i.badge = faceting_handler_i.faceting_data[facet_key].count
#              facet_total++
#              links_data.push(link_facet_i)
#
#          if @standaloneMode
#            paintThisFacetGroup = true
#          else
#            paintThisFacetGroup = (@collection.meta.key_name == @search_bar_view.selected_es_entity)
#
#          if facet_total > 0 and paintThisFacetGroup
#            SideMenuHelper.addMenu(menu_key,
#              {
#                title: facet_group.label
#                title_badge: facet_total
#                links: links_data
#                show_on_render: faceting_handler_i.hasSelection()
#              }
#            )
#        SideMenuHelper.renderMenus()