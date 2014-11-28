var modSenseAction = angular.module("modSenseAction", ["modFloatLabel"]);

modSenseAction.directive("submitCancelButtons", function() {
  return {
    restrict: "E",
    templateUrl: "senses/actions/submit_cancel_buttons.html"
  }
});
