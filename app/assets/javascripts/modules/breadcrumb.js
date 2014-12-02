var modBreadcrumb = angular.module("modBreadcrumb", []);

modBreadcrumb.factory("Breadcrumb", function($rootScope) {
  var exports = {};
  var items   = [];

  exports.reset = function() {
    items   = [];
  };

  exports.addItem = function (key, url) {
    if (url[0] != "#") {
      url = "#" + url;
    }
    items.push({ title: key, url: url });
  };

  exports.addTranslateItem = function (key, url) {
    $translate(key).then(function(titleTranslation) {
      exports.addItem(titleTranslation, url);
    });
  };

  exports.getItems = function() {
    return items;
  };

  return exports;
});

modBreadcrumb.directive("breadcrumb", function() {

  function BreadcrumbController($scope, $rootScope, Breadcrumb) {
    $rootScope.$on("$routeChangeStart", function(event, next, current){
      Breadcrumb.reset();
    });

    this.getItems = function() {
      return Breadcrumb.getItems();
    }

    Breadcrumb.reset();
  }

  return {
    restrict: "E",
    replace: true,
    templateUrl: "bread_crumb_view.html",
    controller: BreadcrumbController,
    controllerAs: "breadcrumbCtrl"
  };
});
