var eterApp = angular.module("eterApp");

eterApp.config(function ($routeProvider) {
  $routeProvider
    .when('/projects', {
      templateUrl: 'views/projects_index.html'
    })
    .when('/projects/:id', {
      templateUrl: 'views/project_show.html'
    })
    .otherwise({
      redirectTo: '/projects'
    });
});
