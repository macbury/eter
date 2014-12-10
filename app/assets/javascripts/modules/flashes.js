var flashMod = angular.module("modFlash", []);

flashMod.factory('FlashFactory', function FlashFactory ($translate) {
  var exports = {};

  exports.internalServerError = function() {
    this.showLocalized("error", "flashes.internal_server_error");
  };

  exports.processingError = function() {
    this.showLocalized("error", "flashes.processing_error");
  };

  exports.unauthorizedError = function() {
    swal({
      title: "Error",
      text: "You need to sign in or sign up before continuing.",
      type: "error",
    }, function(){
      window.location.href = "/";
    });
  };

  exports.notFoundError = function() {
    this.showLocalized("error", "flashes.not_found");
  };

  exports.undefinedStatus = function(status) {
    this.show("error", "Could not handle status: " + status);
  };

  exports.handleHttpStatusError = function (status) {
    if (status == 401) {
      this.unauthorizedError();
    } else if (status == 500) {
      this.internalServerError();
    } else if (status == 422) {
      this.processingError();
    } else if (status == 404) {
      this.notFoundError();
    } else {
      this.undefinedStatus(status);
    }
  }

  exports.showLocalized = function (type, key) {
    if(type == "alert") {
      type = "error";
    } else if (type == "notice") {
      type = "success";
    }

    $translate("flashes."+type).then(function(typeTranslation) {
      $translate(key).then(function(keyTranslation) {
        sweetAlert(typeTranslation, keyTranslation, type);
      });
    });
  };

  exports.show = function (type, message) {
    if(type == "alert") {
      type = "error";
    } else if (type == "notice") {
      type = "success";
    }

    $translate("flashes."+type).then(function(translation) {
      sweetAlert(translation, message, type);
    });
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
