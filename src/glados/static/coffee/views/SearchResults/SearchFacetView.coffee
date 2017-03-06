glados.useNameSpace 'glados.views.SearchResults',
  # View that renders the search facet to filter results
  SearchFacetView: Backbone.View.extend

    initialize: () ->
      # @collection - must be provided in the constructor call
      @el = $('.collapsible.collapsible-accordion.side-nav')
      @handlebars_template = Handlebars.compile($('#Handlebars-SideBar-CollapsibleMenu').html())
      @collection.on 'reset do-repaint sort', @render, @

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
              filter_val = key_i
              link_facet_i.href = window.location.href+encodeURI(' +'+faceting_handler_i.es_property_name+':'+key_i+'')
              link_facet_i.label = key_i
              link_facet_i.badge = faceting_handler_i.faceting_data[key_i]
              facet_total += faceting_handler_i.faceting_data[key_i]
              links_data.push(link_facet_i)
            $(@el).find('.faceting_menu_'+facet_key_i).remove()
            html_menu = @handlebars_template(
              menu_class: 'faceting_menu_'+facet_key_i
              title: facet_i.label
              title_badge: facet_total
              links: links_data
            )
            $(@el).append(html_menu)
          $(@el).find('li').removeClass('active')
          $(@el).find('.collapsible-header').removeClass('active')
          li_tiem = $(@el).find('.collapsible-header')
          $(li_tiem[1]).trigger('click')

      else
        $(@el).find('.navigation-menu').find('.collapsible-header').addClass('active')