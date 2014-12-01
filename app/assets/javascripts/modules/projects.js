var modProject = angular.module("modProject", ["modPartition", "modSense"]);

modProject.factory("ProjectResource", function($http, $q) {
  var exports  = {};

  exports.all = function() {
    var deferred = $q.defer();
    $http({ method: "GET", url: "/projects.json" }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      deferred.reject(status);
      //show error
    });

    return deferred.promise;
  };

  exports.create = function(project) {
    var deferred = $q.defer();
    $http.post("/projects", { project: project }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      var errors = {};
      if (data != null && data.errors != null) {
        errors = data.errors;
      }
      deferred.reject(errors);
    });

    return deferred.promise;
  }

  exports.find = function(project_id) {
    var deferred = $q.defer();
    $http({ method: "GET", url: "/projects/"+project_id+".json" }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      deferred.reject(status);
      //show error
    });

    return deferred.promise;
  };

  return exports;
});


modProject.controller("DashboardProjectsController", function DashboardProjectsController ($scope, $rootScope, ProjectResource, Browser, Routes, FlashFactory) {
  $scope.projects = null;
  Browser.setLocalizedTitle("projects.header");
  this.isEmpty = function() { return $scope.projects != null && $scope.projects.length == 0; }

  ProjectResource.all().then(function(projects) {
    $scope.projects = projects;
  }, function (status) {
    FlashFactory.handleHttpStatusError(status);
  });

  this.projectUrl = function(projectJson) {
    return '#'+Routes.projectUrl({project_id: projectJson.id});
  }
});

modProject.controller("ProjectController", function ProjectController ($scope, $rootScope, ProjectResource, Browser, $routeParams, SenseService, $location, FlashFactory) {
  $scope.project = null;

  var project_id = $routeParams['id'];
  SenseService.putContext("project_id", project_id);
  ProjectResource.find(project_id).then(function(project) {
    $scope.project = project;
    Browser.setTitle(project.title);
  }, function (status) {
    $location.path("/projects");
    FlashFactory.handleHttpStatusError(status);
  });
});

modProject.directive("createProjectAction", function($timeout, ProjectResource, $location, Routes) {

  function CreateProjectController($scope) {
    $scope.project = { title: $scope.senseAction.payload.title };
    $scope.loading = false;

    $timeout(function() {
      $scope.$broadcast('titleFieldFocus');
    }, 100);

    this.isLoading = function () {
      return $scope.loading;
    }

    this.create = function () {
      $scope.loading = true;
      ProjectResource.create($scope.project).then(function ProjectCreated(data) {
        $location.replace();
        $location.url(Routes.projectUrl({project_id: data.id}));
        $scope.$root.$broadcast("closeSenseMenu");
      }, function ProjectCreationError(errors) {
        $.each(errors, function(field, errorFieldMessages) {
          $scope.projectForm[field].$dirty = true;
          $scope.projectForm[field].$setValidity('server', false);
          $scope.projectForm[field].serverErrors = errorFieldMessages;
        });
        $scope.loading = false;
      });

    }
  }

  return {
    restrict: "E",
    templateUrl: "senses/actions/create_project_sense.html",
    controller: CreateProjectController,
    controllerAs: "createProjectCtrl"
  }
});


modProject.directive("projectCard", function() {
  return {
    restrict: "E",
    templateUrl: "projects/project_card.html"
  }
});
