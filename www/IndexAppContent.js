cordova.define("cordova-plugin-indexappcontent", function(require, exports, module) {
  var exec = require("cordova/exec");

  var IndexAppContent = function () {
  };

  IndexAppContent.prototype.init = function (onSuccess, onError) {
    exec(null, null, "IndexAppContent", "deviceIsReady", []);
  };

  IndexAppContent.prototype.setItems = function (items, onSuccess, onError) {
    exec(onSuccess, onError, "IndexAppContent", "setItems", [items]);
  };
  
  IndexAppContent.prototype.clearItemsForDomains = function (domains, onSuccess, onError) {
    exec(onSuccess, onError, "IndexAppContent", "clearItemsForDomains", [domains]);
  };
  
  IndexAppContent.prototype.setIndexingInterval = function (interval, onSuccess, onError) {
    exec(onSuccess, onError, "IndexAppContent", "setIndexingInterval", [interval]);
  };

  module.exports = new IndexAppContent();
});
