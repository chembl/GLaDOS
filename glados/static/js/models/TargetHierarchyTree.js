// Generated by CoffeeScript 1.4.0
var TargetHierarchyTree;

TargetHierarchyTree = Backbone.Model.extend({
  defaults: {
    'children': new TargetHierarchyChildren,
    'all_nodes': new TargetHierarchyChildren
  },
  initialize: function() {
    return this.on('change', this.initHierarhy, this);
  },
  initHierarhy: function() {
    var addOneNode, all_nodes, all_nodes_dict, child, children_col, node, plain, _i, _j, _len, _len1, _ref, _ref1;
    plain = {};
    plain['name'] = this.get('name');
    plain['children'] = this.get('children');
    this.set('plain', plain, {
      silent: true
    });
    all_nodes = new TargetHierarchyChildren;
    children_col = new TargetHierarchyChildren;
    all_nodes_dict = {};
    this.set('depth', 0, {
      silent: true
    });
    addOneNode = function(node_obj, children_col, parent, parent_depth) {
      var child_obj, grand_children_coll, my_depth, new_node, _i, _len, _ref, _results;
      my_depth = parent_depth + 1;
      grand_children_coll = new TargetHierarchyChildren;
      new_node = new TargetHierarchyNode({
        name: node_obj.name,
        id: node_obj.id,
        parent: parent,
        children: grand_children_coll,
        size: node_obj.size,
        depth: my_depth,
        is_leaf: node_obj.children.length === 0,
        selected: false
      });
      children_col.add(new_node);
      all_nodes.add(new_node);
      all_nodes_dict[node_obj.id] = new_node;
      if (node_obj.children != null) {
        _ref = node_obj.children;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          child_obj = _ref[_i];
          _results.push(addOneNode(child_obj, grand_children_coll, new_node, my_depth));
        }
        return _results;
      }
    };
    _ref = this.get('children');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      if (node != null) {
        addOneNode(node, children_col, void 0, 0);
      }
    }
    this.set('all_nodes_dict', all_nodes_dict, {
      silent: true
    });
    this.set('all_nodes', all_nodes, {
      silent: true
    });
    this.set('children', children_col, {
      silent: true
    });
    _ref1 = this.get('children').models;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      child = _ref1[_j];
      child.set('show', true, {
        silent: true
      });
      child.set('collapsed', true, {
        silent: true
      });
    }
    return this.collapseAll();
  },
  collapseAll: function() {
    var child, _i, _len, _ref, _results;
    _ref = this.get('children').models;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      _results.push(child.collapseMeAndMyDescendants());
    }
    return _results;
  },
  expandAll: function() {
    var child, _i, _len, _ref, _results;
    _ref = this.get('children').models;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      _results.push(child.expandMeAndMyDescendants());
    }
    return _results;
  },
  selectAll: function() {
    var node, _i, _len, _ref, _results;
    _ref = this.get('all_nodes').models;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      node.set('selected', true);
      _results.push(node.set('incomplete', false));
    }
    return _results;
  },
  clearSelections: function() {
    var node, _i, _len, _ref, _results;
    _ref = this.get('all_nodes').models;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      node.set('selected', false);
      _results.push(node.set('incomplete', false));
    }
    return _results;
  },
  searchInTree: function(terms) {
    var node, numFound, termsUpper, _i, _len, _ref;
    this.collapseAll();
    termsUpper = terms.toUpperCase();
    numFound = 0;
    _ref = this.get('all_nodes').models;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      node.set('found', false);
      if (node.get('name').toUpperCase().indexOf(termsUpper) !== -1) {
        node.set('found', true);
        node.expandMyAncestors();
        numFound++;
      }
    }
    return numFound;
  },
  resetSearch: function() {
    var node, _i, _len, _ref;
    _ref = this.get('all_nodes').models;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      node = _ref[_i];
      node.set('found', false);
    }
    return this.collapseAll();
  }
});
