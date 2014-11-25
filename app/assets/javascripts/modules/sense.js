var senseMod = angular.module("modSense", ["modFlash"]);

senseMod.factory("SenseService", function($http, $q, $timeout) {
  var exports       = {};
  var query        = null;
  var searchTimer  = null;
  var queryRequest = null;
  var sensePromise = null;

  function executeSearch() {
    resetSearchTimer();
    $http.post("/sense", { sense: { query: query } }).success(function(data, status) {
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

  exports.cancel = function CancelFunction() {
    resetSearchTimer();
    resetQueryRequest();
    resetPromise();
  }

  exports.sense = function SenseFunction(query_text) {
    this.cancel();
    sensePromise = $q.defer();

    if (query_text.length > 0) {
      searchTimer  = $timeout(executeSearch, 500);
      query        = query_text;
    } else {
      sensePromise.reject("invalid");
    }

    return sensePromise.promise;
  }

  return exports;
});

senseMod.directive("senseView", function SenseViewDirective($http, $location, SenseService, FlashFactory) {
  function SenseViewController($scope) {
    $scope.showResults = false;
    $scope.loading     = false;
    $scope.searchText  = "";
    $scope.suggestions = [];

    this.haveSuggestions = function() {
      return $scope.suggestions.length > 0;
    }

    this.search        = function() {
      $scope.loading = true;
      SenseService.sense($scope.searchText).then(function( suggestions ) {
        $scope.suggestions = suggestions;
        $scope.loading     = false;
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
        console.log("key down");
      } else if(event.keyCode===38){
        event.preventDefault();
        console.log("key up");
      } else if(event.keyCode===13){ //enter pressed
        event.preventDefault();
        console.log("enter");
      }
    };

    this.showMenu = function () {
      $scope.showResults = true;
    };

    this.clear    = function() {
      $scope.searchText  = "";
      $scope.showResults = false;
      $scope.suggestions = [];
      $scope.loading     = false;
      SenseService.cancel();

    };

    this.isShowingResults = function () {
      return $scope.showResults || $scope.searchText.length > 0 || $scope.loading;
    };

    this.isLoading = function () {
      return $scope.loading;
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
