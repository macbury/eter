var senseMod = angular.module("senseMod", []);

senseMod.directive("senseView", function SenseViewDirective() {
  function SenseViewController($scope) {
    $scope.test = "Test1234";
  }

  return {
    restrict: "E",
    templateUrl: "sense_view.html",
    controller: SenseViewController,
    replace: true
  };
});
