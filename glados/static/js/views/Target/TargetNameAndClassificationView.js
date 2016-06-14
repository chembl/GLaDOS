// Generated by CoffeeScript 1.4.0
var TargetNameAndClassificationView;

TargetNameAndClassificationView = CardView.extend({
  initialize: function() {
    this.model.on('change', this.render, this);
    return this.model.on('error', this.showCompoundErrorCard, this);
  },
  render: function() {
    this.render_for_large();
    return this.showVisibleContent();
  },
  render_for_large: function() {
    var table_large, template;
    table_large = $(this.el).find('#BCK-TNC-large');
    template = $('#' + table_large.attr('data-hb-template'));
    return table_large.html(Handlebars.compile(template.html())({
      chembl_id: this.model.get('target_chembl_id'),
      type: this.model.get('target_type'),
      pref_name: this.model.get('pref_name'),
      synonyms: this.get_target_syonyms_list(this.model.get('target_components')),
      organism: this.model.get('organism'),
      specs_group: this.model.get('species_group_flag') ? 'Yes' : 'No',
      prot_target_classification: 'Enzyme'
    }));
  },
  /* *
    * Give me the target_components list from the web services response and I will
    * return a list with the synoyms only.
    * @param {Array} target_components, array of objects from the response.
    * @return {Array} array with the synonyms, it can be empty if there are none
  */

  get_target_syonyms_list: function(target_components) {
    var component, syn_struc, synonyms, _i, _j, _len, _len1, _ref;
    synonyms = [];
    for (_i = 0, _len = target_components.length; _i < _len; _i++) {
      component = target_components[_i];
      _ref = component['target_component_synonyms'];
      for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
        syn_struc = _ref[_j];
        if (syn_struc['syn_type'] !== 'EC_NUMBER') {
          synonyms.push(syn_struc['component_synonym']);
        }
      }
    }
    return synonyms;
  }
});
