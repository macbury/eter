var eterApp = angular.module("eterApp", [ "ngAnimate", "modSenseAction", "modBrowser", "modFlash", "pascalprecht.translate", "modSense", "ngRoute", "modProject", 'angular-loading-bar', 'mopInclude', 'modActivities', 'modRoute', "modFloatLabel", "angular-spinkit", "modBreadcrumb", "bootstrap-tagsinput", "modError",
"LocalStorageModule", "modCanCan"]);
var Rails   = {};

eterApp.factory('railsLocalesLoader', function RailsLocalesLoader($http) {
  return function(options) {
    return $http.get(options.key+".json").then(function(response) {
      return response.data;
    }, function() {
      throw(options.key);
    });
  };
});

eterApp.config(function Config($provide, $httpProvider, $translateProvider, BrowserProvider, localStorageServiceProvider) {
  BrowserProvider.setAppName("Eter");

  localStorageServiceProvider
    .setPrefix('eter')
    .setStorageType('localStorage')
    .setNotify(true, true);

  $httpProvider.defaults.headers.common['X-CSRF-Token'] = angular.element(document.querySelector('meta[name=csrf-token]')).attr('content');

  $provide.factory('railsAssetsInterceptor', function RailsAssetsIntercreptor($cacheFactory) {

    return {
      request: function RailsAssetsIntercreptorRequest (config) {
        var assetUrl = Rails.templates[config.url];
        if (assetUrl != null) {
          config.url = assetUrl;
        }
        return config;
      }
    };
  });

  $httpProvider.interceptors.push('railsAssetsInterceptor');

  if (Rails.env != "development") {
    $provide.service("$templateCache", function($cacheFactory) {
      return $cacheFactory('templateCache', {
        maxAge: 3600000 * 24 * 7,
        storageMode: 'localStorage',
        recycleFreq: 60000
      });
    });
  }

  $translateProvider.useLoader('railsLocalesLoader');
  $translateProvider.preferredLanguage(Rails.locale.locale);
});

$.getJSON("/api/angular.json", function(resp) {
  Rails = resp;

  angular.element(document).ready(function() {
    angular.bootstrap(document, ['eterApp']);
  });
});
