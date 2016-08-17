// Generated by CoffeeScript 1.4.0
var DrugBrowserInfinityView;

DrugBrowserInfinityView = Backbone.View.extend(PaginatedViewExt).extend({
  initialize: function() {
    this.collection.on('reset do-repaint sort', this.render, this);
    this.isInfinte = true;
    return $(this.el).find('select').material_select();
  },
  render: function() {
    this.fill_template('DrugInfBrowserCardsContainer');
    this.hideInfiniteBrPreolader();
    return this.setUpLoadingWaypoint();
  }
});
