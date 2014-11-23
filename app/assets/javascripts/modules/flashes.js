var flashMod = angular.module("flashMod", []);

flashMod.factory('FlashFactory', function FlashFactory () {
  var exports = {};

  exports.show = function (type, message) {
    if(type == "alert") {
      type = "error";
    } else if (type == "notice") {
      type = "success";
    }

    sweetAlert(type, message, type);
  };

  return exports;
});

flashMod.directive("flash", function FlashMod(FlashFactory, $timeout) {
  return {
    restrict: "A",
    link: function FlashLink($scope, element, attrs, ctrl) {
      element.hide();
      $timeout(function() {
        FlashFactory.show(attrs["type"], element.text())
      }, 1000);
    },
  };
});
