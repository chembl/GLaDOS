// Generated by CoffeeScript 1.4.0
var AssayBasicInformationView;

AssayBasicInformationView = CardView.extend({
  initialize: function() {
    return this.model.on('change', this.render, this);
  },
  render: function() {
    return this.render_for_large();
  },
  render_for_large: function() {
    var table_large, template;
    table_large = $(this.el).find('#BCK-ABI-large');
    template = $('#' + table_large.attr('data-hb-template'));
    return table_large.html(Handlebars.compile(template.html())({
      chembl_id: this.model.get('assay_chembl_id'),
      type: this.model.get('assay_type_description'),
      description: this.model.get('description'),
      format: this.model.get('bao_format'),
      organism: this.model.get('assay_organism'),
      strain: this.model.get('assay_strain'),
      cell_type: this.model.get('cell_type'),
      subcellular_fraction: this.model.get('assay_subcellular_fraction')
    }));
  }
});
