var modActivities = angular.module("modActivities", []);

modActivities.directive("activitiesView", function() {
  return {
    restrict: "E",
    templateUrl: "activities_view.html"
  }
});
