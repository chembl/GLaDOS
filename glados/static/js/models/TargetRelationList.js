// Generated by CoffeeScript 1.4.0
var TargetRelationList;

TargetRelationList = PaginatedCollection.extend({
  model: TargetRelation,
  parse: function(data) {
    return data.target_relations;
  },
  initialize: function() {
    this.meta = {
      page_size: 10,
      current_page: 1,
      available_page_sizes: Settings.TABLE_PAGE_SIZES,
      to_show: [],
      columns: [
        {
          'name_to_show': 'ChEMBL ID',
          'comparator': 'target_chembl_id',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort',
          'link_base': '/target_report_card/$$$'
        }, {
          'name_to_show': 'Relationship',
          'comparator': 'relationship',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort'
        }, {
          'name_to_show': 'Pref Name',
          'comparator': 'pref_name',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort'
        }, {
          'name_to_show': 'Target Type',
          'comparator': 'target_type',
          'sort_disabled': false,
          'is_sorting': 0,
          'sort_class': 'fa-sort'
        }
      ]
    };
    return this.on('reset', this.resetMeta, this);
  },
  fetch: function() {
    var base_url2, getTargetRelations, target_relations, this_collection;
    this_collection = this;
    target_relations = {};
    getTargetRelations = $.getJSON(this.url, function(data) {
      return target_relations = data.target_relations;
    });
    getTargetRelations.fail(function() {
      console.log('error');
      return this_collection.trigger('error');
    });
    base_url2 = Settings.WS_DEV_BASE_URL + 'target.json?target_chembl_id__in=';
    return getTargetRelations.done(function() {
      var getTargetsInfo, getTargetssInfoUrl, t, targets_list;
      targets_list = ((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = target_relations.length; _i < _len; _i++) {
          t = target_relations[_i];
          _results.push(t.target_chembl_id);
        }
        return _results;
      })()).join(',');
      getTargetssInfoUrl = base_url2 + targets_list + '&order_by=target_chembl_id&limit=1000';
      getTargetsInfo = $.getJSON(getTargetssInfoUrl, function(data) {
        var i, targ, targets, _i, _len;
        targets = data.targets;
        i = 0;
        for (_i = 0, _len = targets.length; _i < _len; _i++) {
          targ = targets[_i];
          if (targ.target_chembl_id !== target_relations[i].target_chembl_id) {
            i++;
          }
          target_relations[i].pref_name = targ.pref_name;
          target_relations[i].target_type = targ.target_type;
          i++;
        }
        return this_collection.reset(target_relations);
      });
      return getTargetsInfo.fail(function() {
        return console.log('failed2');
      });
    });
  }
});
