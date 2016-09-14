// Generated by CoffeeScript 1.4.0
var DocumentBasicInformationView;

DocumentBasicInformationView = CardView.extend(DownloadViewExt).extend({
  initialize: function() {
    this.model.on('change', this.render, this);
    this.model.on('error', this.showCompoundErrorCard, this);
    return this.resource_type = 'Document';
  },
  render: function() {
    this.fill_template('BCK-DBI-large');
    this.fill_template('BCK-DBI-small');
    this.showVisibleContent();
    this.initEmbedModal('basic_information');
    return this.activateModals();
  },
  fill_template: function(div_id) {
    var div, template;
    div = $(this.el).find('#' + div_id);
    template = $('#' + div.attr('data-hb-template'));
    return div.html(Handlebars.compile(template.html())({
      doc_id: this.model.get('document_chembl_id'),
      journal: this.model.get('journal'),
      year: this.model.get('year'),
      volume: this.model.get('volume'),
      first_page: this.model.get('first_page'),
      last_page: this.model.get('last_page'),
      pubmed_id: this.model.get('pubmed_id'),
      doi: this.model.get('doi')
    }));
  },
  getFilename: function(format) {
    if (format === 'csv') {
      return this.model.get('document_chembl_id') + 'DocumentBasicInformation.csv';
    } else if (format === 'json') {
      return this.model.get('document_chembl_id') + 'DocumentBasicInformation.json';
    } else if (format === 'xls') {
      return this.model.get('document_chembl_id') + 'DocumentBasicInformation.xls';
    } else {
      return 'file.txt';
    }
  }
});
