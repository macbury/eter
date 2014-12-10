var modCanCan = angular.module("modCanCan", []);

modCanCan.factory('CanCan', function() {
  var exports = {};

  exports.can = function(key, object) {
    return (object['permission'] != null && object['permission'][key] == true);
  };

  return exports;
});
