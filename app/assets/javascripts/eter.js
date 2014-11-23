
function boot_with_rails(rails_env) {
  var eterApp = angular.module("eterApp", ["flashMod"]);
  eterApp.constant('Rails', rails_env)
  console.log(rails_env);
}
