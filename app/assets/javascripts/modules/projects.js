var modProject = angular.module("modProject", ["modPartition", "modSense"]);

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

  exports.find = function(project_id) {
    var deferred = $q.defer();
    $http({ method: "GET", url: "/projects/"+project_id+".json" }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      deferred.reject();
      //show error
    });

    return deferred.promise;
  };

  return exports;
});


modProject.controller("DashboardProjectsController", function DashboardProjectsController ($scope, $rootScope, ProjectResource, Browser, Routes) {
  $scope.projects = null;
  Browser.setLocalizedTitle("projects.header");
  this.isEmpty = function() { return $scope.projects != null && $scope.projects.length == 0; }

  ProjectResource.all().then(function(projects) {
    $scope.projects = projects;
  });

  this.projectUrl = function(projectJson) {
    return '#'+Routes.projectUrl({project_id: projectJson.id});
  }
});

modProject.controller("ProjectController", function ProjectController ($scope, $rootScope, ProjectResource, Browser, $routeParams, SenseService) {
  $scope.project = null;

  var project_id = $routeParams['id'];
  SenseService.putContext("project_id", project_id);
  ProjectResource.find(project_id).then(function(project) {
    $scope.project = project;
    Browser.setTitle(project.title);
  });
});

modProject.directive("projectCard", function() {
  return {
    restrict: "E",
    templateUrl: "projects/project_card.html"
  }
});
