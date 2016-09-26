// Generated by CoffeeScript 1.4.0
var DrugBrowserTableView;

DrugBrowserTableView = Backbone.View.extend(PaginatedViewExt).extend({
  initialize: function() {
    this.collection.on('reset do-repaint sort', this.render, this);
    this.$preloaderContainer = $('#DB-MainContent');
    return this.$contentContainer = this.$preloaderContainer;
  },
  render: function() {
    this.clearTable();
    this.fill_template('DBTable-large');
    this.fillPaginator('DB-paginator');
    this.fillPageSelector();
    this.activateSelectors();
    return this.showVisibleContent();
  },
  clearTable: function() {
    return $('#DBTable-large').empty();
  }
});
