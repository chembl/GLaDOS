// Generated by CoffeeScript 1.4.0
var CompoundMoleculeFormsListView;

CompoundMoleculeFormsListView = CardView.extend({
  initialize: function() {
    this.collection.on('reset', this.render, this);
    return this.collection.on('error', this.showCompoundErrorCard, this);
  },
  render: function() {
    console.log('render');
    this.addAllAlternateForms();
    $(this.el).children('.card-preolader-to-hide').hide();
    $(this.el).children(':not(.card-preolader-to-hide, .card-load-error)').show();
    this.initEmbedModal('alternate_forms');
    this.renderModalPreview();
    return this.activateTooltips();
  },
  addOneAlternateForm: function(alternateForm) {
    var row, view;
    console.log('oneAlternate form');
    console.log(alternateForm);
    view = new CompoundMoleculeFormView({
      model: alternateForm
    });
    row = $(this.el).find('#Bck-AlternateForms');
    return row.append(view.render().el);
  },
  addAllAlternateForms: function() {
    return this.collection.forEach(this.addOneAlternateForm, this);
  }
});
