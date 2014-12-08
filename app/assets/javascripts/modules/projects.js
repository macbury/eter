var modProject = angular.module("modProject", ["modPartition", "modSense"]);

modProject.factory("ProjectResource", function($http, $q, FlashFactory) {
  var exports  = {};

  exports.all = function() {
    var deferred = $q.defer();
    $http({ method: "GET", url: "/api/projects.json" }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      deferred.reject(status);
      //show error
    });

    return deferred.promise;
  };

  exports.create = function(project) {
    var deferred = $q.defer();
    $http.post("/api/projects", { project: project }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      if (status != 200) {
        FlashFactory.handleHttpStatusError(status);
        deferred.reject([]);
      } else {
        var errors = {};
        if (data != null && data.errors != null) {
          errors = data.errors;
        }
        deferred.reject(errors);
      }
    });

    return deferred.promise;
  }

  exports.find = function(project_id) {
    var deferred = $q.defer();
    $http({ method: "GET", url: "/api/projects/"+project_id+".json" }).success(function(data, status, headers, config) {
      deferred.resolve(data);
    }).error(function(data, status, headers, config) {
      deferred.reject(status);
      //show error
    });

    return deferred.promise;
  };

  return exports;
});


modProject.directive("projectsDashboard", function() {
  function DashboardProjectsController ($scope, $rootScope, ProjectResource, Browser, Routes, FlashFactory) {
    $scope.activeProjects = null;
    Browser.setLocalizedTitle("projects.header");
    this.isEmpty = function() { return $scope.projects != null && $scope.projects.length == 0; }

    ProjectResource.all().then(function(projects) {
      $scope.activeProjects = projects;
    }, function (status) {
      FlashFactory.handleHttpStatusError(status);
    });

    this.projectUrl = function(projectJson) {
      return '#'+Routes.projectUrl({project_id: projectJson.id});
    }
  };

  return {
    restrict: "E",
    controller: DashboardProjectsController,
    controllerAs: "projectsController"
  };
});

modProject.directive("projectGroup", function() {
  return {
    restrict: "E",
    templateUrl: "projects/project_group.html",
    controller: function ProjectGroupController($scope, localStorageService, $timeout) {
      $scope.visible    = false;
      $timeout(function () {
        $scope.visible = localStorageService.get($scope.groupTitleTranslationKey) == "true";
      });
      this.haveProjects = function() { return $scope.projects != null && $scope.projects.length == 0; };
      this.toggle       = function() {
        $scope.visible = !$scope.visible;
        localStorageService.set($scope.groupTitleTranslationKey, $scope.visible);
      };
      this.getArrowClass = function (argument) {
        if ($scope.visible) {
          return "fa-arrow-down";
        } else {
          return "fa-arrow-right"
        }
      }
    },
    controllerAs: "projectGroupCtrl",
    link: function (scope, element, attrs, ctrls) {
      scope.$watch(attrs["projects"], function(newValue, oldValue) {
        scope.projects = newValue;
      });
      scope.groupTitleTranslationKey = attrs["title"];
    }
  }
});

modProject.controller("ProjectController", function ProjectController ($scope, $rootScope, ProjectResource, Browser, $routeParams, SenseService, $location, FlashFactory, Breadcrumb, Routes) {
  $scope.project = null;

  var project_id = $routeParams['id'];
  SenseService.putContext("project_id", project_id);
  ProjectResource.find(project_id).then(function(project) {
    $scope.project = project;
    Browser.setTitle(project.title);
    Breadcrumb.addItem(project.title, Routes.projectUrl({ project_id: project.id }));
  }, function (status) {
    $location.path("/projects");
    FlashFactory.handleHttpStatusError(status);
  });
});

modProject.directive("createProjectAction", function($timeout, ProjectResource, $location, Routes, FormError, FlashFactory) {

  function CreateProjectController($scope) {
    $scope.project = { title: $scope.senseAction.payload.title, members_emails: "" };
    $scope.loading = false;

    $timeout(function() {
      $scope.$broadcast('titleFieldFocus');
    }, 100);

    this.isLoading = function () {
      return $scope.loading;
    };

    this.create = function () {
      $scope.loading = true;
      ProjectResource.create($scope.project).then(function ProjectCreated(data) {
        $location.url(Routes.projectUrl({project_id: data.id}));
        $scope.$root.$broadcast("closeSenseMenu");
      }, function ProjectCreationError(errors) {
        FormError.applyToForm(errors, $scope.projectForm);
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

modProject.directive("projectTitleInput", function() {
  return {
    restrict: "E",
    replace: false,
    template: [
    '<float-label errors="projectForm.title.serverErrors" placeholder="simple_form.labels.project.title" for="project_title" name="title">',
      '<input type="text" name="title" id="project_title" class="form-control" focus-on="projectTitleFieldFocus" ng-model="project.title" autocomplete="off" />',
    '</float-label>'
    ].join("\n")
  }
});

modProject.directive("projectScm", function() {
  return {
    restrict: "E",
    replace: false,
    template: [
      '<float-label errors="projectForm.scm.serverErrors" placeholder="simple_form.labels.project.title" for="project_title" name="title">',
        '<input type="text" name="title" id="project_title" class="form-control" focus-on="projectTitleFieldFocus" ng-model="project.title" autocomplete="off" />',
      '</float-label>'
    ].join("\n")
  }
});

modProject.directive("projectActivityGraph", function() {
  return {
    restrict: "E",
    link: function(scope, element, attrs) {
      scope.$watch("project.activity", function(newVal, oldVal) {
        $(element).sparkline(newVal, {
          type: 'bar',
          barColor: 'rgba(255, 255, 255, 0.3)',
          barSpacing: 1,
          height: '24',
          barWidth: 6
        });
      });
    }
  }
});

modProject.directive("projectMembersInput", function() {
  function LinkMembersAutocomplete(scope, element, attrs) {
    var input = element.find("input");

    input.on('tokenfield:removedtoken', function (e) {
      setTimeout(function() {
        input.trigger("update:label");
      }, 100)
    });

    input.on('tokenfield:createdtoken', function (e) {
      var re = /([a-z0-9_\-\.]+@[a-z0-9_\-\.]+\.[a-z0-9_\-\.]+)/
      var valid = re.test(e.attrs.value)
      if (!valid) {
        $(e.relatedTarget).addClass('invalid')
      }
    })

    input.tokenfield({
      autocomplete: {
        minLength: 2,
        source: '/api/members',
        delay: 300
      },
      showAutocompleteOnFocus: true
    });


    element.find(".token-input").on("change keyup input blur", function() {
      input.trigger("update:label", $(this).val());
    });
  }

  return {
    restrict: "E",
    replace: false,
    link: LinkMembersAutocomplete,
    template: [
    '<float-label errors="projectForm.members.serverErrors" ng-model="project.member_emails" placeholder="simple_form.labels.project.members" for="project_members" name="members_emails">',
      '<input type="text" name="members_emails" id="project_members" class="form-control" focus-on="projectMembersFieldFocus" ng-model="project.members_emails" autocomplete="off" />',
      '<p class="help-block">{{ "simple_form.hints.project.members" | translate }}</p>',
    '</float-label>'
    ].join("\n")
  }
});
