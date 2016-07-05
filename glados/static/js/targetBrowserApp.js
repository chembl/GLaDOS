// Generated by CoffeeScript 1.4.0
var TargetBrowserApp;

TargetBrowserApp = (function() {
  /* *
    * Initializes a target hierarchy tree
    * return {TargetHierarchyTree}
  */

  function TargetBrowserApp() {}

  TargetBrowserApp.initTargetHierarchyTree = function() {
    var targetTree;
    targetTree = new TargetHierarchyTree;
    return targetTree;
  };

  TargetBrowserApp.initBrowserAsList = function(model, top_level_elem) {
    var asListView;
    asListView = new BrowseTargetAsListView({
      model: model,
      el: top_level_elem
    });
    return asListView;
  };

  return TargetBrowserApp;

})();
