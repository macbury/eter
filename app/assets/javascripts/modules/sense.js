var senseMod = angular.module("modSense", []);

senseMod.directive("senseView", function SenseViewDirective() {
  function SenseViewController($scope) {
    $scope.showResults = false;

    this.toggleResults = function () {
      $scope.showResults = !$scope.showResults;
    };

    this.showResults = function () {
      $scope.showResults = true;
    };

    this.hideResults = function () {
      $scope.showResults = false;
    };

    this.isShowingResults = function () {
      return $scope.showResults;
    };

    this.isLoading = function () {
      return false;
    };

  }

  return {
    restrict: "E",
    templateUrl: "sense_view.html",
    controller: SenseViewController,
    controllerAs: "senseCtrl",
    replace: true
  };
});
