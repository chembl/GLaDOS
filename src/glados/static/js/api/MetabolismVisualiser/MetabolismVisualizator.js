class MetabolismVisualizator {

    static _EMBL_GREEN() { return '#71B360'};
    static _EMBL_PETROL() { return '#020169'};
    static _LIGHT_BLUE() { return '#819FF7'};
    static _EMBL_GRAY() { return '#294D51'};
    static _GRAY() { return 'gray'};
    
    
    
    static _get_nodes_style() {

        const style = {

            selector: 'node',
                style: {
                'height': 80,
                        'width': 80,
                        'background-fit': 'cover',
                        'border-color': MetabolismVisualizator._EMBL_PETROL(),
                        'border-width': 2,
                        'border-opacity': 0.5,
                        'label': 'data(pref_name)',
                        'font-size': 12,
                        'shape': 'rectangle'

                }
        }

        return style;
    }

    static _get_edges_style(){

        return {

            selector: 'edge',
                    style: {
                    'width': 3,
                            'line-color': MetabolismVisualizator._LIGHT_BLUE(),
                            'target-arrow-color': MetabolismVisualizator._LIGHT_BLUE(),
                            'target-arrow-shape': 'triangle',
                            'label': 'data(enzyme)',
                            'font-size': 10,
                            'color': 'black',
                            'width': 2,
                            'curve-style': 'bezier'
                            
                            
                    }

        };
    }

    static _get_graph_layout(){

        return {
            name: 'dagre'
        };
    }



    /**
     * initializes cytoscape with the parameters given. after the initialisation the graph must have been painted
     * @param container,_id container that is going to paint the graph
     * @param elements, nodes and links in the format required by cytoscape
     * @param stylesheet, structure that defines how the graph is going to be painted
     * @param layout, structure that the fines the layout that you want for the graph
     * @return  the cytoscape instance.
     */
    static _initCytoscape(container_id, elements, stylesheet, layout) {

        var cy = cytoscape({

                container: document.getElementById(container_id),
                elements: elements,
                style: stylesheet,
                layout: layout

        });
        return cy;
    }

    /**
     * returns the elements, and stylesheet objects from the graph description in the data
     * @param data graph description, nodes and links
     * @param nodes_style, the style that you want for the nodes
     * @param edges_style, the style that you want for the edges
     * @return an object with 2 elements: "elems" and "stylesheet" to be used directly into cytoscape
     */
    static _getElemsAndSylesheetFromData(data, nodes_style, edges_style) {

        const base_img_link = 'https://www.ebi.ac.uk/chembl/api/data/image/'
        const base_img_backup_link = 'https://www.ebi.ac.uk/chembl/compound/displayimage_large/'

        let ans = {}
        ans.elems = []
        ans.stylesheet = []

        ans.stylesheet.push(nodes_style);
        ans.stylesheet.push(edges_style);
        
        console.log('Edges Styles!');
        console.log(edges_style);
        
        // From each node I see, what can I add to the object?
        for (let node of data.nodes) {

            let newItem = {
            data: {
                id: node.chembl_id,
                'pref_name': node.pref_name,
                'is_current': node.is_current,
                'doc_chembl_id': node.doc_chembl_id,
                'has_structure': node.has_structure,
                'molregno': node.molregno
            }
            }

            const ws_img_url = `${base_img_link}${node.chembl_id}.svg?engine=indigo`
            const backup_img_url = `${base_img_backup_link}${node.molregno}`

            const background_img = node.has_structure ? ws_img_url: backup_img_url;

            ans.elems.push(newItem);
            let newStyle = {
                    selector: `#${node.chembl_id}`,
                    style: {

                        'background-image': background_img,
                        'background-color': '#FFF'
                    }
            }

            if (node.is_current){
            newStyle.style['border-width'] = 4;
                    newStyle.style['border-color'] = MetabolismVisualizator._EMBL_GREEN();
            }

            ans.stylesheet.push(newStyle)
        }

        // From each edge I see, what can I add to the object?
        // this counter is to make sure that each edge has a unique id
        let i = 0
        // this is to know which edges share the same source and target
        let connections = {}
        for (let edge of data.edges) {

            let source = data.nodes[edge.source]
            let target = data.nodes[edge.target]
            
            let edge_id = `${i}_${source.chembl_id}_${edge.enzyme}_${target.chembl_id}`
            
            let source_target_str = `${source.chembl_id}_${target.chembl_id}`
            
            if (connections[source_target_str] == null)
                connections[source_target_str] = []
                
            connections[source_target_str].push(edge_id)

            let newItem = {
                
                data: {
                    id: edge_id,
                    source: source.chembl_id,
                    target: target.chembl_id,
                    enzyme: edge.enzyme,
                    met_conversion: edge.met_conversion,
                    organism: edge.organism,
                    doc_chembl_id: edge.doc_chembl_id,
                    enzyme_chembl_id: edge.enzyme_chembl_id,
                    references_list: edge.references_list
                }
            }
            ans.elems.push(newItem)

            i++
        }
        
        console.log('For cytoscape!');
        console.log(ans);
        return ans;
    }

    static _get_cytoscape_instance(container_id, data){

        const cyElemsAndStyle = MetabolismVisualizator._getElemsAndSylesheetFromData(data, MetabolismVisualizator._get_nodes_style(), MetabolismVisualizator._get_edges_style());
        const cy = MetabolismVisualizator._initCytoscape(container_id, cyElemsAndStyle.elems, cyElemsAndStyle.stylesheet, MetabolismVisualizator._get_graph_layout());
        // qtips for nodes
        cy.nodes().forEach(function(n){

            const pref_name = n.data('pref_name');
            const chembl_id = n.data('id');
            
            const ws_img = `https://www.ebi.ac.uk/chembl/api/data/image/${chembl_id}?engine=indigo`
            const backup_img = `https://www.ebi.ac.uk/chembl/compound/displayimage_large/${n.data('molregno')}`
            
            const img_link = n.data('has_structure') ? ws_img: backup_img
            
            const compound_link = ` <a target ="_blank" href = '/compound_report_card/${chembl_id}'> ${chembl_id} </a>`;
            const compound_img = `<img style='width: 100%' src='${img_link}'>`
            const colour_class = 'qtip-bootstrap'
            const text = ` <h3> ${compound_link}</h3> ${compound_img}`;

            n.qtip({

                content: {
                    'title': pref_name,
                    'text': text,
                    button: 'Close'
                },
                    position: {
                    my: 'top center',
                    at: 'bottom center'
                },
                style: {
                    classes: `${colour_class} qtip-rounded qtip-shadow`,
                }
            });
        });
            // qtips for edges
        cy.edges().forEach(function(e){

            const enzyme = e.data('enzyme');
            const enzyme_chembl_id = e.data('enzyme_chembl_id');
            
            const enzyme_text = enzyme_chembl_id != undefined ? `<a target ="_blank" href = '/chembl/target/inspect/${enzyme_chembl_id}'> ${enzyme_chembl_id}</a>`:"--";
            
            const met_conversion = e.data('met_conversion');
            const met_conversion_text = met_conversion != undefined ? met_conversion : "--";
            
            const doc_chembl_id = e.data('doc_chembl_id');
            const doc_chembl_id_link = `<a target ="_blank" href = '/chembl/doc/inspect/${doc_chembl_id}'> ${doc_chembl_id}</a>`;
            const organism = e.data('organism')
            const organism_text = organism != undefined ? ` <b> Organism: </b> ${organism}` : "--";
            
            const references_list = e.data('references_list') != undefined ? e.data('references_list'): ''
            const refs_items = references_list != '' ? references_list.split('|'): [];      
            
            let i = 0;
            const refs_links = refs_items.map((item) => { i++; return `<a target='_blank' href='${item}'>[${i}]</a>`;}).join(' ');
                
            const refs_list = `${refs_links}`
            

       
            let text = `<table style="width:100%">
                    
                      <tr><th>Enzyme:</th></tr>
                      <tr><td>${enzyme_text}</td></tr>
                      
                      <tr><th>Conversion:</th></tr>
                      <tr><td>${met_conversion_text}</td></tr>
                    
                      <tr><th>Document:</th></tr>
                      <tr><td>${doc_chembl_id_link}</td></tr>
                      
                      <tr><th>Organism:</th></tr>
                      <tr><td>${organism_text}</td></tr>
                      
                      <tr><th>References:</th></tr>
                      <tr><td>${refs_list}</td></tr>
                    
                    </table>`

            // There is currently a exception for CHEMBL612545, only for this case
            // we must not show the enzyme chembl id and text
            // CHEMBL612545 is just a placeholder
            if (enzyme_chembl_id == 'CHEMBL612545'){
                
                text = `<table style="width:100%">
                      
                      <tr><th>Conversion:</th></tr>
                      <tr><td>${met_conversion_text}</td></tr>
                    
                      <tr><th>Document:</th></tr>
                      <tr><td>${doc_chembl_id_link}</td></tr>
                      
                      <tr><th>Organism:</th></tr>
                      <tr><td>${organism_text}</td></tr>
                      
                      <tr><th>References:</th></tr>
                      <tr><td>${refs_list}</td></tr>
                    
                    </table>`
            
                }
            
            
            e.qtip({

            content: {
                'title': enzyme,
                'text': text,
                button: 'Close'
            },
            position: {
                my: 'top center',
                at: 'bottom center'
            },
            style: {
                classes: 'qtip-bootstrap qtip-rounded qtip-shadow'
            }

            });
            
        });
        return cy;
    }

    static _loadDataAndRender(container_id, data_src){

        $.getJSON(data_src, function(data) {

            console.log('data received!');
            console.log(data);
            console.log('^^^^^^');
            MetabolismVisualizator._get_cytoscape_instance(container_id, data);
        });
    }


    static _loadFromVariable(container_id, data){

        console.log('data from variable!');
        console.log(data);
        console.log('^^^^^^');
        MetabolismVisualizator._get_cytoscape_instance(container_id, data);
        console.log('DONE');
    }



}
