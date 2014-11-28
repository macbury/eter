var modFloatLabel = angular.module("modFloatLabel", []);

var uniqueId = 100;

function TextInputLink(scope, element, attrs, ngModel) {
  var input = element.find("input, textarea");
  uniqueId  += 1;
  scope.elementId = scope.name +"_"+uniqueId;
  function swapLabels() {
    if (ngModel.$isEmpty(ngModel.$viewValue)) {
      input.addClass("empty");
    } else {
      input.removeClass("empty");
    }
  }

  function updateErrors() {
    // body...
  }

  ngModel.$render = function() { swapLabels(); };

  scope.$watch(ngModel, function() {
    input.val(ngModel.$viewValue);
    updateErrors();
    swapLabels();
  });

  input.on('keyup change', function () {
    ngModel.$setViewValue(input.val());
    ngModel.$render();
  });
}

modFloatLabel.directive('focusOn', function() {
  return function(scope, elem, attr) {
    scope.$on(attr.focusOn, function(e) {
      elem[0].selectionStart = elem[0].selectionEnd = elem.val().length;
      elem[0].focus();
    });
  };
});

modFloatLabel.directive("textAreaInput", function() {
  return {
    restrict: "E",
    replace: true,
    require: "ngModel",
    link: TextInputLink,
    scope: {
      "placeholder": "@placeholder",
    },
    template: [
    '<div class="form-group float-label-control">',
    '<textarea type="text" name="{{ elementId }}" id="{{ elementId }}" class="form-control" placeholder="{{ placeholder | translate }}"></textarea>',
    '<label for="{{ elementId }}">{{ placeholder | translate }}</label>',
    '</div>'
    ].join("\n")
  }
});

modFloatLabel.directive("textInput", function() {

  return {
    restrict: "E",
    replace: true,
    require: "ngModel",
    link: TextInputLink,
    scope: {
      "placeholder": "@placeholder",
      "name": "@name"
    },
    template: [
      '<div class="form-group float-label-control">',
        '<input type="text" name="{{ name }}" id="{{ elementId }}" class="form-control" placeholder="{{ placeholder | translate }}" focus-on="{{ name + \'FieldFocus\' }}">',
        '<label for="{{ name }}">{{ placeholder | translate }}</label>',
      '</div>'
    ].join("\n")
  }
});
