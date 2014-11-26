var modRoute = angular.module("modRoute", []);


modRoute.factory("Routes", function($location) {
  var exports = {};

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
