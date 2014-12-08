var senseMod = angular.module("modSense", ["modFlash", "modRoute"]);

senseMod.factory("SenseService", function($http, $q, $timeout, $rootScope) {
  var exports       = {};
  var context      = {};
  var query        = null;
  var searchTimer  = null;
  var queryRequest = null;
  var sensePromise = null;

  $rootScope.$on('$routeChangeSuccess', function (event, current, previous) {
    exports.clearContext();
  });

  function executeSearch() {
    resetSearchTimer();

    var sense_params = {};
    angular.copy(context, sense_params);
    sense_params["query"] = query;
    $http.post("/api/sense", { sense: sense_params }).success(function(data, status) {
      resetQueryRequest();

      if (status == 200) {
        sensePromise.resolve(data);
      } else if (status == 403 || status == 401 || status == 422) {
        sensePromise.reject("unauthorized");
      } else {
        sensePromise.reject("error");
        throw "Unsupported status for sense: #{code}"
      }
      sensePromise = null;
    }).error(function(data, status, headers, config) {
      resetQueryRequest();
      sensePromise.reject("error");
      sensePromise = null;
    });
  }

  function resetSearchTimer() {
    if (searchTimer != null) {
      $timeout.cancel(searchTimer);
      searchTimer = null;
    }
  }

  function resetQueryRequest() {
    if (queryRequest != null) {
      queryRequest.abort();
      queryRequest = null;
    }
  }

  function resetPromise() {
    if (sensePromise != null) {
      sensePromise.reject("cancel");
      sensePromise = null;
    }
  };

  exports.clearContext = function() {
    context = {};
  };

  exports.putContext = function(key, value) {
    context[key] = value;
  };

  exports.cancel = function CancelFunction() {
    resetSearchTimer();
    resetQueryRequest();
    resetPromise();
  }

  exports.sense = function SenseFunction(query_text) {
    this.cancel();
    sensePromise = $q.defer();

    if (query_text.length > 0) {
      searchTimer  = $timeout(executeSearch, 200);
      query        = query_text;
    } else {
      sensePromise.reject("invalid");
    }

    return sensePromise.promise;
  }

  return exports;
});

senseMod.directive("senseView", function SenseViewDirective($http, $location, SenseService, FlashFactory, Routes, $timeout) {
  function SenseViewController($scope) {
    $scope.suggestionIndex = 0;
    $scope.showResults = false;
    $scope.loading     = false;
    $scope.searchText  = "";
    $scope.suggestions = [];
    $scope.currentSense = null;

    $scope.$on("closeSenseMenu", angular.bind(this, function() {
      this.clearAndFocus();
    }));

    this.loadActionFromUrl = function() {
      var action = $location.search()["action"];
      if (action != null) {
        try {
          action = JSON.parse(atob(action));
          this.startAction(action);
        } catch(e) {

        }
      } else {
        $scope.currentSense = null;
      }
    }

    this.haveSuggestions = function() {
      return $scope.suggestions.length > 0;
    }

    this.reset = function() {
      $scope.loading = false;
      $scope.suggestionIndex = 0;
      $scope.suggestions = [];
      $scope.showResults = false;
      $scope.currentSense = null;
    }

    this.search        = function() {
      this.reset();
      $scope.loading = true;
      SenseService.sense($scope.searchText).then(function( suggestions ) {
        $scope.loading     = false;
        $scope.suggestions = suggestions;
      }, function(error) {
        if (error == "error") {
          $scope.loading = false;
          FlashFactory.showLocalized("error", "flashes.internal_server_error");
        } else if (error == "unauthorized") {
          $scope.loading = false;
          FlashFactory.showLocalized("error", "flashes.unauthorized_access");
        } else if (error == "invalid") {
          $scope.loading = false;
        }
      });

    };

    this.checkKeyDown  = function(event) {
      if(event.keyCode===40){
        event.preventDefault();
        if ($scope.suggestionIndex < $scope.suggestions.length - 1){
          $scope.suggestionIndex++;
        }
      } else if(event.keyCode===38){
        event.preventDefault();
        if ($scope.suggestionIndex > 0){
          $scope.suggestionIndex--;
        }
      } else if(event.keyCode===13){ //enter pressed
        event.preventDefault();

        var senseAction = $scope.suggestions[$scope.suggestionIndex];
        this.startAction(senseAction);
      }
    };

    this.startAction = function (senseAction) {
      var redirectTo = Routes.getUrlForAction(senseAction);
      if (redirectTo != null) {
        this.clear();
        $location.path(redirectTo);
      } else {
        this.reset();
        $scope.currentSense = senseAction;
      }
    }

    this.showMenu = function () {
      $scope.showResults = true;
    };

    this.clear    = function() {
      $scope.searchText  = "";
      this.reset();
      SenseService.cancel();
    };

    this.focus    = function() {
      $timeout(function() {
        $scope.$broadcast('queryInputFocus');
      }, 100);
    };

    this.clearAndFocus = function() {
      this.clear();
      this.focus();
    }

    this.isShowingResults = function () {
      return $scope.showResults || $scope.searchText.length > 0 || $scope.loading || $scope.currentSense != null;
    };

    this.isLoading = function () {
      return $scope.loading;
    };

    this.loadActionFromUrl();
  }

  return {
    restrict: "E",
    templateUrl: "senses/sense_view.html",
    controller: SenseViewController,
    controllerAs: "senseCtrl",
    replace: true
  };
});

senseMod.directive("senseActionLink", function($location, Routes) {

  function SenseActionLinkController($scope) {
    this.actionUrl = function() {
      var redirectTo = Routes.getUrlForAction($scope.senseAction);
      if (redirectTo != null) {
        return "#"+redirectTo;
      } else {
        return Routes.actionUrl($scope.senseAction);
      }
    };

    this.haveRedirect = function() {
      return Routes.getUrlForAction($scope.senseAction) != null;
    };

    this.onActionClick = function($event) {
      if (this.haveRedirect()) {
        $scope.onRedirectClick();
      } else {
        $event.preventDefault();
        $scope.onActionClick($scope.senseAction);
      }
    };
  }

  return {
    restrict: "E",
    controller: SenseActionLinkController,
    controllerAs: "senseActionCtrl",
    templateUrl: "senses/action_link.html",
    scope: {
      "onActionClick": "&onActionClick",
      "onRedirectClick": "&onRedirectClick",
      "senseAction": "=action"
    },
    replace: true
  }
});

senseMod.directive("senseGroupMe", function() {
  return {
    restrict: "E",
    replace: true,
    templateUrl: "senses/group_me.html"
  }
});

senseMod.directive("senseGroupLoading", function() {
  return {
    restrict: "E",
    replace: true,
    templateUrl: "senses/group_loading.html",
    scope: {
      "isLoading": "&isLoading",
    }
  }
});

senseMod.directive("senseAction", function($compile) {
  function SenseActionLink(scope, element, attrs) {
    scope.$watch("senseAction", function(newVal, oldVal) {
      var senseAction = scope.senseAction;
      if (senseAction != null) {
        var elementName = senseAction.action.replace(/_/g, "-");

        element.html("<"+elementName+"></"+elementName+">").show();
        $compile(element.contents())(scope);
      } else {
        element.hide();
      }
    });
  };

  return {
    restrict: "E",
    replace: true,
    link: SenseActionLink,
    scope: {
      "senseAction": "=senseAction"
    }
  }
});
