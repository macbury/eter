var modError = angular.module("modError", []);

modError.factory("FormError", function() {
  var exports = {};

  exports.applyToForm = function(errors, form) {
    $.each(errors, function(field, errorFieldMessages) {
      if (form[field] != null) {
        form[field].$dirty = true;
        form[field].$setValidity('server', false);
        form[field].serverErrors = errorFieldMessages;
      }

    });
  };

  return exports;
});
