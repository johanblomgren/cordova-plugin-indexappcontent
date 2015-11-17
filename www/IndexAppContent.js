cordova.define("cordova-plugin-indexappcontent.IndexAppContent", function(require, exports, module) {
  var exec = require("cordova/exec");

  var IndexAppContent = function () {
  };

  IndexAppContent.prototype.setItems = function (items, onSuccess, onError) {
    exec(onSuccess, onError, "IndexAppContent", "setItems", [items]);
  };
  
  IndexAppContent.prototype.clearItemsForDomains = function (domains, onSuccess, onError) {
    exec(onSuccess, onError, "IndexAppContent", "clearItemsForDomains", [domains]);
  };
  
  IndexAppContent.prototype.init = function (items, onSuccess, onError) {
    exec(null, null, "IndexAppContent", "deviceIsReady", []);
  };

  module.exports = new IndexAppContent();

  // call the plugin as soon as deviceready fires, this makes sure the webview is loaded,
  // way more solid than relying on native's pluginInitialize.
  // document.addEventListener('deviceready', function() {
  //   exec(null, null, "IndexAppContent", "deviceIsReady", []);
  // }, false);
});
