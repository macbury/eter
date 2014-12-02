var modRails = angular.module("modRails", []);

modRails.provider('Rails', function() {
  var angularEnv = null;

  this.$get = function($http, $q) {
    var exports = {};

    exports.getEnv       = function () {
      var deffer = $q.defer();

      if (angularEnv == null) {
        $http.get("/angular.json").success(function (data) {
          angularEnv = data;
          deffer.resolve(angularEnv);
        }).error(function() {
          deffer.reject();
          throw "Could not get env!!!!";
        });
      } else {
        deffer.resolve(angularEnv);
      }

      return deffer.promise;
    }

    exports.getAssetPath = function (assetPath) {
      var deffer = $q.defer();

      exports.getEnv().then(function(env) {
        deffer.resolve(env.templates[assetPath]);
      });

      return deffer.promise;
    }

    return exports;
  };
});
