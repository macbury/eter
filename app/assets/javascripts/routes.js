var eterApp = angular.module("eterApp");

eterApp.config(function ($routeProvider) {
  $routeProvider
    .when('/projects', {
      templateUrl: 'views/projects_index.html'
    })
    .otherwise({
      redirectTo: '/projects'
    });
});
