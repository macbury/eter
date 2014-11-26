var modBrowser = angular.module("modBrowser", []);

modBrowser.provider('Browser', function() {
  var appName      = "None";
  var currentTitle = null;


  this.setAppName = function(newAppName) {
    appName = newAppName;
  }

  this.$get = function($rootScope, $translate, $window) {
    var exports = {};

    $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
      exports.updateTitle();
    });

    exports.setTitle = function(pageTitle) {
      currentTitle = pageTitle;
      exports.updateTitle();
    };

    exports.setLocalizedTitle = function (titleKey) {
      $translate(titleKey).then(function(titleTranslation) {
        exports.setTitle(titleTranslation);
      });
    };

    exports.getTitle = function () {
      return [appName, currentTitle].join(" - ");
    }

    exports.updateTitle = function() {
      $window.document.title = exports.getTitle();
    }

    return exports;
  };

});
