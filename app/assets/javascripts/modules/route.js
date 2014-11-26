var modRoute = angular.module("modRoute", []);


modRoute.factory("Routes", function($location) {
  var exports = {};

  exports.currentUrl = function CurrentUrl(params) {
    var q = $.merge(params, $location.search());
    return '#'+$location.path() + "?"+$.param(q);
  };

  return exports;
});
