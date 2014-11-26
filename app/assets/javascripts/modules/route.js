var modRoute = angular.module("modRoute", []);


modRoute.factory("Routes", function($location) {
  var exports = {};

  exports.getUrlForAction = function(senseAction) {
    var path   = senseAction["payload"]["path"];
    var params = senseAction["payload"]["path_params"];
    if (path != null && params != null) {
      var urlFunc = exports[path+"Url"];
      if (urlFunc != null) {
        return urlFunc(params);
      }
    }

    return null;
  };

  exports.projectUrl = function(params) {
    return '/projects/' + params['project_id'];
  };

  exports.actionUrl = function ActionUrl(senseAction) {
    var q = btoa(JSON.stringify(senseAction));
    return '#'+$location.path() + "?"+$.param({ action: q });
  };

  exports.currentUrl = function CurrentUrl(params) {
    var q = $.merge(params, $location.search());
    return '#'+$location.path() + "?"+$.param(q);
  };

  return exports;
});
