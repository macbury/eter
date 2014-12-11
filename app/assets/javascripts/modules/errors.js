var modError = angular.module("modError", []);

modError.factory("FormError", function() {
  var exports = {};

  exports.reset       = function (resource, form) {
    $.each(resource, function(field, value) {
      if (form[field] != null) {
        form[field].$dirty = false;
        form[field].$setValidity('server', true);
        form[field].serverErrors = null;
      }
    });
  };

  exports.applyToForm = function(errors, form) {
    $.each(errors, function(field, errorFieldMessages) {
      if (form[field] != null) {
        form[field].$dirty = true;
        form[field].$setValidity('server', false);
        form[field].serverErrors = errorFieldMessages;
      } else {
        console.log("skip field: ", [field, errorFieldMessages, form]);
      }

    });
  };

  return exports;
});
