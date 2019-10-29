glados.useNameSpace 'glados.views.Compound',
  MetabolismView: Backbone.View.extend
    initialize: ->
      @model.on 'change', @render, @

    render: ->

      @loadFromVariable($(@el).attr('id'), @model.get('graph'))
    # ----------------------------------------------------------------------------------------------------------------------
    # default style
    # ----------------------------------------------------------------------------------------------------------------------
    getNodesStyle: ->

      return {
        selector: 'node'
        style:
          'height': 80,
          'width': 80,
          'background-fit': 'cover',
          'border-color': glados.Settings.VIS_COLORS.TEAL3,
          'border-width': 2,
          'border-opacity': 0.7,
          'label': 'data(pref_name)',
          'font-size': 11,
          'shape': 'rectangle'
      }

    getEdgesStyle: ->

        return {
          selector: 'edge',
          style:
            'line-color': glados.Settings.VIS_COLORS.TEAL5,
            'target-arrow-color': glados.Settings.VIS_COLORS.TEAL5,
            'target-arrow-shape': 'triangle',
            'label': 'data(enzyme)',
            'font-size': 9,
            'color': glados.Settings.VIS_COLORS.TEAL1,
            'width': 2,
            'curve-style': 'bezier'
        }

    getGraphLayout: ->

      return {
        name: 'dagre'
      }


#     initializes cytoscape with the parameters given. after the initialisation the graph must have been painted
#     @param container,_id container that is going to paint the graph
#     @param elements, nodes and links in the format required by cytoscape
#     @param stylesheet, structure that defines how the graph is going to be painted
#     @param layout, structure that the fines the layout that you want for the graph
#     @return  the cytoscape instance.
    initCytoscape: (container_id, elements, stylesheet, layout) ->

      cy = cytoscape(
        container: document.getElementById(container_id),
        elements: elements,
        style: stylesheet,
        layout: layout
      )
      return cy

#     returns the elements, and stylesheet objects from the graph description in the data
#     @param data graph description, nodes and links
#     @param nodes_style, the style that you want for the nodes
#     @param edges_style, the style that you want for the edges
#     @return an object with 2 elements: "elems" and "stylesheet" to be used directly into cytoscape
    getElemsAndSylesheetFromData: (data, nodes_style, edges_style)  ->

        base_img_link = glados.Settings.WS_BASE_URL+'image/'
        base_img_backup_link = 'https://www.ebi.ac.uk/chembl/compound/displayimage_large/'

        ans = {}
        ans.elems = []
        ans.elems = []
        ans.stylesheet = []

        ans.stylesheet.push(nodes_style)
        ans.stylesheet.push(edges_style)


        # From each node I see, what can I add to the object?
        for node in data.nodes

          newItem =
            data:
              id: node.chembl_id,
              pref_name: node.pref_name,
              is_current: node.is_current,
              doc_chembl_id: node.doc_chembl_id,
              has_structure: node.has_structure,
              image_file: node.image_file

          ws_img_url = "#{base_img_link}#{node.chembl_id}.svg?engine=indigo"
          backup_img_url = "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{node.image_file}"
          background_img = if node.has_structure then ws_img_url else backup_img_url
          ans.elems.push(newItem)

          newStyle =
            selector: "##{node.chembl_id}",
            style:
              'background-image': background_img,
              'background-color': "white"

          if node.is_current
            newStyle.style['border-width'] = 4
            newStyle.style['border-color'] = glados.Settings.VIS_COLORS.ORANGE2

          ans.stylesheet.push(newStyle)


        # From each edge I see, what can I add to the object?
        # this counter is to make sure that each edge has a unique id
        i = 0
        # this is to know which edges share the same source and target
        connections = {}
        for edge in data.edges

          source = data.nodes[edge.source]
          target = data.nodes[edge.target]

          edge_id = "#{i}_#{source.chembl_id}_#{edge.enzyme}_#{target.chembl_id}"

          source_target_str = "#{source.chembl_id}_#{target.chembl_id}"

          if not connections[source_target_str]?
            connections[source_target_str] = []

          connections[source_target_str].push(edge_id)

          newItem =
            data:
              id: edge_id,
              source: source.chembl_id,
              target: target.chembl_id,
              enzyme: edge.enzyme,
              met_conversion: edge.met_conversion,
              organism: edge.organism,
              doc_chembl_id: edge.doc_chembl_id,
              enzyme_chembl_id: edge.enzyme_chembl_id,
              references_list: edge.references_list

          ans.elems.push(newItem)
          i++

        return ans

    getCytoscapeInstance: (container_id, data) ->

        cyElemsAndStyle = @getElemsAndSylesheetFromData(data, @getNodesStyle(), @getEdgesStyle())
        cy = @initCytoscape(container_id, cyElemsAndStyle.elems, cyElemsAndStyle.stylesheet, @getGraphLayout())
        # qtips for nodes
        cy.nodes().forEach (n) ->

          pref_name = n.data('pref_name')
          chembl_id = n.data('id')

          ws_img = glados.Settings.WS_BASE_URL+"image/#{chembl_id}?engine=indigo"
          backup_img =  "#{glados.Settings.STATIC_IMAGES_URL}compound_placeholders/#{n.data('image_file')}"

          img_link = if n.data('has_structure') then ws_img else backup_img
          compound_link = " <a target ='_blank' href = '/compound_report_card/#{chembl_id}'> #{chembl_id} </a>"
          compound_img = "<img style='width: 100%' src='#{img_link}'>"
          colour_class = 'qtip-bootstrap'
          text = " <h3> #{compound_link}</h3> #{compound_img}"

          n.qtip
            content:
              'title': pref_name,
              'text': text,
              button: 'Close'
            ,position:
              my: 'top center',
              at: 'bottom center'
            ,style:
              classes: "#{colour_class} qtip-rounded qtip-shadow"


        # qtips for edges
        cy.edges().forEach (e) ->

          enzyme = e.data('enzyme')
          enzyme_chembl_id = e.data('enzyme_chembl_id')

          if enzyme_chembl_id?
            enzyme_text = "<a target ='_blank' href = \
              '#{Target.get_report_card_url(enzyme_chembl_id)}'> #{enzyme_chembl_id}</a>"
          else
            enzyme_text = "--"

          met_conversion = e.data('met_conversion')
          met_conversion_text = if met_conversion? then met_conversion else '--'

          doc_chembl_id = e.data('doc_chembl_id')
          # Disable this until it's in elasticsearch
#          doc_chembl_id_link = "<a target ='_blank' href = \
#            '#{Document.get_report_card_url(doc_chembl_id)}'> #{doc_chembl_id}</a>"

          doc_chembl_id_link = '---'

          organism = e.data('organism')
          organism_text = if organism? then " <b> Organism: </b> #{organism}" else '--'

          references_list = if e.data('references_list')? then e.data('references_list') else ''
          refs_items = if references_list != '' then references_list.split('|') else []

          i = 0
          refs_links = refs_items.map((item) ->  i++; return "<a target='_blank' href='#{item}'>[#{i}]</a>").join(' ')
          refs_list = "#{refs_links}"

          text = "<table style='width:100%'>

            <tr><th>Enzyme:</th></tr>
            <tr><td>#{enzyme_text}</td></tr>

            <tr><th>Conversion:</th></tr>
            <tr><td>#{met_conversion_text}</td></tr>

            <tr><th>Document:</th></tr>
            <tr><td>#{doc_chembl_id_link}</td></tr>

            <tr><th>Organism:</th></tr>
            <tr><td>#{organism_text}</td></tr>

            <tr><th>References:</th></tr>
            <tr><td>#{refs_list}</td></tr>

          </table>"

          # There is currently a exception for CHEMBL612545, only for this case
          # we must not show the enzyme chembl id and text
          # CHEMBL612545 is just a placeholder
          if enzyme_chembl_id == 'CHEMBL612545'

            text = "<table style='width:100%'>

              <tr><th>Conversion:</th></tr>
              <tr><td>#{met_conversion_text}</td></tr>

              <tr><th>Document:</th></tr>
              <tr><td>#{doc_chembl_id_link}</td></tr>

              <tr><th>Organism:</th></tr>
              <tr><td>#{organism_text}</td></tr>

              <tr><th>References:</th></tr>
              <tr><td>#{refs_list}</td></tr>

            </table>"

          e.qtip
            content:
              'title': enzyme
              'text': text
              button: 'Close'
            ,position:
              my: 'top center'
              at: 'bottom center'
            ,style:
              classes: 'qtip-bootstrap qtip-rounded qtip-shadow'

        return cy

    loadFromVariable: (container_id, data) -> @getCytoscapeInstance(container_id, data)
