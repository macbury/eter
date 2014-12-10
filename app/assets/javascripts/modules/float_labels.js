var modFloatLabel = angular.module("modFloatLabel", []);

var uniqueId = 100;

function TextInputLink(scope, element, attrs, ctrls) {
  var input = element.find("input, textarea");

  function swapLabels(text) {
    if (text == undefined || text == null || text.length == 0 || typeof(text) != "string") {
      text = input.val();
    }
    if (text == undefined || text == null || text.length == 0 || text == "") {
      element.addClass("empty");
    } else {
      element.removeClass("empty");
    }
  }

  scope.getErrorClass = function() {
    if (scope.errors == null) {
      return "";
    } else {
      return "ng-invalid";
    }
  }

  input.on("update:label", function(ev, text) {
    swapLabels(text);
  });
  input.on("change keyup blur focus input", swapLabels);
  scope.$parent.$watch(scope.model, function(newValue, oldValue) {
    if (newValue == null) {
      swapLabels();
    } else {
      swapLabels(""+newValue);
    }
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

modFloatLabel.directive("floatLabel", function() {
  return {
    restrict: "EA",
    transclude: true,
    replace: true,
    link: TextInputLink,
    scope: {
      "placeholder": "@placeholder",
      "for": "@for",
      "errors": "=errors",
      "model": "@model"
    },
    template: [
    '<div class="form-group float-label-control" ng-class="getErrorClass()">',
      '<span ng-transclude></span>',
      '<label for="{{ for }}">{{ placeholder | translate }}</label>',
      '<p class="help-block-error" ng-show="errors">{{ errors.join(", ") }}</p>',
    '</div>'
    ].join("\n")
  }
});


modFloatLabel.directive("autocompleteInput", function() {
  function TokenLink(scope, element, attrs, ngModel) {
    var input = element.find("input");
    input.on('tokenfield:createtoken', function (e) {
      var data = e.attrs.value.split('|')
      e.attrs.value = data[1] || data[0]
      e.attrs.label = data[1] ? data[0] + ' (' + data[1] + ')' : data[0]
    })

    .on('tokenfield:createdtoken', function (e) {
      // Über-simplistic e-mail validation
      var re = /\S+@\S+\.\S+/
      var valid = re.test(e.attrs.value)
      if (!valid) {
        $(e.relatedTarget).addClass('invalid')
      }
    })

    .on('tokenfield:edittoken', function (e) {
      if (e.attrs.label !== e.attrs.value) {
        var label = e.attrs.label.split(' (')
        e.attrs.value = label[0] + '|' + e.attrs.value
      }
    })

    .on('tokenfield:removedtoken', function (e) {
      alert('Token removed! Token value was: ' + e.attrs.value)
    })

    input.tokenfield({
      autocomplete: {
        minLength: 2,
        source: '/members',
        delay: 300
      },
      showAutocompleteOnFocus: true
    });

    element.find("input").on("change keyup input", function() {
      scope.$broadcast("update:label");
    })
  }

  return {
    restrict: "A",
    link: TokenLink
  }
})
