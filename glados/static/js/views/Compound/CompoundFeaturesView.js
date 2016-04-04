// Generated by CoffeeScript 1.4.0
var CompoundFeaturesView;

CompoundFeaturesView = CardView.extend({
  initialize: function() {
    this.model.on('change', this.render, this);
    return this.model.on('error', this.showCompoundErrorCard, this);
  },
  render: function() {
    this.renderProperty('Bck-MolType', 'molecule_type');
    this.renderProperty('Bck-FirstInClass', 'first_in_class');
    this.renderProperty('Bck-Chirality', 'chirality');
    this.renderProperty('Bck-Prodrug', 'prodrug');
    this.renderProperty('Bck-Oral', 'oral');
    this.renderProperty('Bck-Parenteral', 'parenteral');
    $(this.el).children('.card-preolader-to-hide').hide();
    $(this.el).children(':not(.card-preolader-to-hide, .card-load-error)').show();
    return this.activateTooltips();
  },
  renderProperty: function(div_id, property) {
    var property_div;
    property_div = $(this.el).find('#' + div_id);
    console.log(property + ':');
    console.log(this.model.get(property));
    return property_div.html(Handlebars.compile($('#Handlebars-Compound-MoleculeFeatures-IconContainer').html())({
      active_class: this.getMolFeatureDetails(property, 0),
      filename: this.getMolFeatureDetails(property, 1),
      tooltip: this.getMolFeatureDetails(property, 2),
      description: this.getMolFeatureDetails(property, 3),
      tooltip_position: this.getMolFeatureDetails(property, 4)
    }));
  },
  getMolFeatureDetails: function(feature, position) {
    return this.molFeatures[feature][this.model.get(feature)][position];
  },
  molFeatures: {
    'molecule_type': {
      'Small molecule': ['active', 'mt_small_molecule', 'Molecule Type: small molecule', 'Small Molecule', 'top'],
      'Antibody': ['active', 'mt_antibody', 'Molecule Type: Antibody', 'Antibody', 'top'],
      'Enzyme': ['active', 'mt_enzyme', 'Molecule Type: Enzyme', 'Enzyme', 'top']
    },
    'first_in_class': {
      '0': ['', 'first_in_class', 'First in Class: No', 'First in Class', 'top'],
      '1': ['active', 'first_in_class', 'First in Class: Yes', 'First in Class', 'top']
    },
    'chirality': {
      '0': ['active', 'chirality_0', 'Chirality: Racemic Mixture', 'Racemic Mixture', 'top'],
      '1': ['active', 'chirality_1', 'Chirality: Single Stereoisomner', 'Single Stereoisomner', 'top'],
      '2': ['', 'chirality_1', 'Chirality: Achiral Molecule', 'Achiral Molecule', 'top']
    },
    'prodrug': {
      '0': ['', 'prodrug', 'Prodrug: No', 'Prodrug', 'top'],
      '1': ['active', 'prodrug', 'Prodrug: Yes', 'Prodrug', 'top']
    },
    'oral': {
      'true': ['active', 'oral', 'Oral: Yes', 'Oral', 'bottom'],
      'false': ['', 'oral', 'Oral: No', 'Oral', 'bottom']
    },
    'parenteral': {
      'true': ['active', 'parenteral', 'Parenteral: Yes', 'Parenteral', 'bottom'],
      'false': ['', 'parenteral', 'Parenteral: No', 'Parenteral', 'bottom']
    }
  }
});
