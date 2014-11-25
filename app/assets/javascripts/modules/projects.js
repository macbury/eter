var modProject = angular.module("modProject", ["modPartition"]);

modProject.factory("ProjectResource", function($http, $q) {
  var exports  = {};

  exports.all = function() {
    var deferred = $q.defer();
    $http({ method: "GET", url: "/projects.json" }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      deferred.reject();
      //show error
    });

    return deferred.promise;
  };

  return exports;
});

modProject.factory("ProjectRoutes", function($location) {
  var exports  = {};

  exports.index = function() {
    $location.path("/projects");
  };

  return exports;
});

modProject.controller("DashboardProjectsController", function DashboardProjectsController ($scope, ProjectResource) {
  $scope.projects = null;

  this.isEmpty = function() { return $scope.projects != null && $scope.projects.length == 0; }

  ProjectResource.all().then(function(projects) {
    $scope.projects = projects;
  });
});
