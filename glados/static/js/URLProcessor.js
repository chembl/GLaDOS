// Generated by CoffeeScript 1.4.0
var URLProcessor;

URLProcessor = (function() {

  function URLProcessor() {}

  URLProcessor.getRequestedChemblID = function() {
    var pathname, pathnameParts;
    pathname = window.location.pathname;
    pathnameParts = pathname.split('/');
    return pathnameParts[pathnameParts.length - 2];
  };

  return URLProcessor;

})();
