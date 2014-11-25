var eterApp = angular.module("eterApp", [ "modFlash", "pascalprecht.translate", "modSense", "ngRoute", "modProject", 'angular-loading-bar', 'mopInclude']);

eterApp.factory('railsLocalesLoader', function RailsLocalesLoader($http) {
  return function(options) {
    return $http.get(options.key+".json").then(function(response) {
      return response.data;
    }, function() {
      throw(options.key);
    });
  };
});

eterApp.config(function Config($provide, $httpProvider, $translateProvider) {
  var Rails = JSON.parse(angular.element(document.querySelector('meta[name=rails]')).attr('content'));
  eterApp.constant('Rails', Rails);

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
  $translateProvider.preferredLanguage('en');
});
