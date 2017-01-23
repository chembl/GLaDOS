'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var MetabolismVisualizator = function () {
    function MetabolismVisualizator() {
        _classCallCheck(this, MetabolismVisualizator);
    }

    _createClass(MetabolismVisualizator, null, [{
        key: '_EMBL_GREEN',
        value: function _EMBL_GREEN() {
            return '#71B360';
        }
    }, {
        key: '_EMBL_PETROL',
        value: function _EMBL_PETROL() {
            return '#020169';
        }
    }, {
        key: '_LIGHT_BLUE',
        value: function _LIGHT_BLUE() {
            return '#819FF7';
        }
    }, {
        key: '_EMBL_GRAY',
        value: function _EMBL_GRAY() {
            return '#294D51';
        }
    }, {
        key: '_GRAY',
        value: function _GRAY() {
            return 'gray';
        }
    }, {
        key: '_get_nodes_style',
        value: function _get_nodes_style() {

            var style = {

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
            };

            return style;
        }
    }, {
        key: '_get_edges_style',
        value: function _get_edges_style() {
            var _style;

            return {

                selector: 'edge',
                style: (_style = {
                    'width': 3,
                    'line-color': MetabolismVisualizator._LIGHT_BLUE(),
                    'target-arrow-color': MetabolismVisualizator._LIGHT_BLUE(),
                    'target-arrow-shape': 'triangle',
                    'label': 'data(enzyme)',
                    'font-size': 10,
                    'color': 'black'
                }, _defineProperty(_style, 'width', 2), _defineProperty(_style, 'curve-style', 'bezier'), _style)

            };
        }
    }, {
        key: '_get_graph_layout',
        value: function _get_graph_layout() {

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

    }, {
        key: '_initCytoscape',
        value: function _initCytoscape(container_id, elements, stylesheet, layout) {

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

    }, {
        key: '_getElemsAndSylesheetFromData',
        value: function _getElemsAndSylesheetFromData(data, nodes_style, edges_style) {

            var base_img_link = 'https://www.ebi.ac.uk/chembl/api/data/image/';
            var base_img_backup_link = 'https://www.ebi.ac.uk/chembl/compound/displayimage_large/';

            var ans = {};
            ans.elems = [];
            ans.stylesheet = [];

            ans.stylesheet.push(nodes_style);
            ans.stylesheet.push(edges_style);

            console.log('Edges Styles!');
            console.log(edges_style);

            // From each node I see, what can I add to the object?
            var _iteratorNormalCompletion = true;
            var _didIteratorError = false;
            var _iteratorError = undefined;

            try {
                for (var _iterator = data.nodes[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                    var node = _step.value;


                    var newItem = {
                        data: {
                            id: node.chembl_id,
                            'pref_name': node.pref_name,
                            'is_current': node.is_current,
                            'doc_chembl_id': node.doc_chembl_id,
                            'has_structure': node.has_structure,
                            'molregno': node.molregno
                        }
                    };

                    var ws_img_url = '' + base_img_link + node.chembl_id + '.svg?engine=indigo';
                    var backup_img_url = '' + base_img_backup_link + node.molregno;

                    var background_img = node.has_structure ? ws_img_url : backup_img_url;

                    ans.elems.push(newItem);
                    var newStyle = {
                        selector: '#' + node.chembl_id,
                        style: {

                            'background-image': background_img,
                            'background-color': '#FFF'
                        }
                    };

                    if (node.is_current) {
                        newStyle.style['border-width'] = 4;
                        newStyle.style['border-color'] = MetabolismVisualizator._EMBL_GREEN();
                    }

                    ans.stylesheet.push(newStyle);
                }

                // From each edge I see, what can I add to the object?
                // this counter is to make sure that each edge has a unique id
            } catch (err) {
                _didIteratorError = true;
                _iteratorError = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion && _iterator.return) {
                        _iterator.return();
                    }
                } finally {
                    if (_didIteratorError) {
                        throw _iteratorError;
                    }
                }
            }

            var i = 0;
            // this is to know which edges share the same source and target
            var connections = {};
            var _iteratorNormalCompletion2 = true;
            var _didIteratorError2 = false;
            var _iteratorError2 = undefined;

            try {
                for (var _iterator2 = data.edges[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
                    var edge = _step2.value;


                    var source = data.nodes[edge.source];
                    var target = data.nodes[edge.target];

                    var edge_id = i + '_' + source.chembl_id + '_' + edge.enzyme + '_' + target.chembl_id;

                    var source_target_str = source.chembl_id + '_' + target.chembl_id;

                    if (connections[source_target_str] == null) connections[source_target_str] = [];

                    connections[source_target_str].push(edge_id);

                    var _newItem = {

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
                    };
                    ans.elems.push(_newItem);

                    i++;
                }
            } catch (err) {
                _didIteratorError2 = true;
                _iteratorError2 = err;
            } finally {
                try {
                    if (!_iteratorNormalCompletion2 && _iterator2.return) {
                        _iterator2.return();
                    }
                } finally {
                    if (_didIteratorError2) {
                        throw _iteratorError2;
                    }
                }
            }

            console.log('For cytoscape!');
            console.log(ans);
            return ans;
        }
    }, {
        key: '_get_cytoscape_instance',
        value: function _get_cytoscape_instance(container_id, data) {

            var cyElemsAndStyle = MetabolismVisualizator._getElemsAndSylesheetFromData(data, MetabolismVisualizator._get_nodes_style(), MetabolismVisualizator._get_edges_style());
            var cy = MetabolismVisualizator._initCytoscape(container_id, cyElemsAndStyle.elems, cyElemsAndStyle.stylesheet, MetabolismVisualizator._get_graph_layout());
            // qtips for nodes
            cy.nodes().forEach(function (n) {

                var pref_name = n.data('pref_name');
                var chembl_id = n.data('id');

                var ws_img = 'https://www.ebi.ac.uk/chembl/api/data/image/' + chembl_id + '?engine=indigo';
                var backup_img = 'https://www.ebi.ac.uk/chembl/compound/displayimage_large/' + n.data('molregno');

                var img_link = n.data('has_structure') ? ws_img : backup_img;

                var compound_link = ' <a target ="_blank" href = \'/compound_report_card/' + chembl_id + '\'> ' + chembl_id + ' </a>';
                var compound_img = '<img style=\'width: 100%\' src=\'' + img_link + '\'>';
                var colour_class = 'qtip-bootstrap';
                var text = ' <h3> ' + compound_link + '</h3> ' + compound_img;

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
                        classes: colour_class + ' qtip-rounded qtip-shadow'
                    }
                });
            });
            // qtips for edges
            cy.edges().forEach(function (e) {

                var enzyme = e.data('enzyme');
                var enzyme_chembl_id = e.data('enzyme_chembl_id');

                var enzyme_text = enzyme_chembl_id != undefined ? '<a target ="_blank" href = \'/target_report_card/' + enzyme_chembl_id + '\'> ' + enzyme_chembl_id + '</a>' : "--";

                var met_conversion = e.data('met_conversion');
                var met_conversion_text = met_conversion != undefined ? met_conversion : "--";

                var doc_chembl_id = e.data('doc_chembl_id');
                var doc_chembl_id_link = '<a target ="_blank" href = \'/document_report_card/' + doc_chembl_id + '\'> ' + doc_chembl_id + '</a>';
                var organism = e.data('organism');
                var organism_text = organism != undefined ? ' <b> Organism: </b> ' + organism : "--";

                var references_list = e.data('references_list') != undefined ? e.data('references_list') : '';
                var refs_items = references_list != '' ? references_list.split('|') : [];

                var i = 0;
                var refs_links = refs_items.map(function (item) {
                    i++;return '<a target=\'_blank\' href=\'' + item + '\'>[' + i + ']</a>';
                }).join(' ');

                var refs_list = '' + refs_links;

                var text = '<table style="width:100%">\n                    \n                      <tr><th>Enzyme:</th></tr>\n                      <tr><td>' + enzyme_text + '</td></tr>\n                      \n                      <tr><th>Conversion:</th></tr>\n                      <tr><td>' + met_conversion_text + '</td></tr>\n                    \n                      <tr><th>Document:</th></tr>\n                      <tr><td>' + doc_chembl_id_link + '</td></tr>\n                      \n                      <tr><th>Organism:</th></tr>\n                      <tr><td>' + organism_text + '</td></tr>\n                      \n                      <tr><th>References:</th></tr>\n                      <tr><td>' + refs_list + '</td></tr>\n                    \n                    </table>';

                // There is currently a exception for CHEMBL612545, only for this case
                // we must not show the enzyme chembl id and text
                // CHEMBL612545 is just a placeholder
                if (enzyme_chembl_id == 'CHEMBL612545') {

                    text = '<table style="width:100%">\n                      \n                      <tr><th>Conversion:</th></tr>\n                      <tr><td>' + met_conversion_text + '</td></tr>\n                    \n                      <tr><th>Document:</th></tr>\n                      <tr><td>' + doc_chembl_id_link + '</td></tr>\n                      \n                      <tr><th>Organism:</th></tr>\n                      <tr><td>' + organism_text + '</td></tr>\n                      \n                      <tr><th>References:</th></tr>\n                      <tr><td>' + refs_list + '</td></tr>\n                    \n                    </table>';
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
    }, {
        key: '_loadDataAndRender',
        value: function _loadDataAndRender(container_id, data_src) {

            $.getJSON(data_src, function (data) {

                console.log('data received!');
                console.log(data);
                console.log('^^^^^^');
                MetabolismVisualizator._get_cytoscape_instance(container_id, data);
            });
        }
    }, {
        key: '_loadFromVariable',
        value: function _loadFromVariable(container_id, data) {

            console.log('data from variable!');
            console.log(data);
            console.log('^^^^^^');
            MetabolismVisualizator._get_cytoscape_instance(container_id, data);
            console.log('DONE');
        }
    }]);

    return MetabolismVisualizator;
}();