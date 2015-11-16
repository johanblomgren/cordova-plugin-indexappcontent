var exec = require("cordova/exec");

var InAppContent = function () {
};

InAppContent.prototype.setItems = function (items, onSuccess, onError) {
  exec(onSuccess, onError, "InAppContent", "setItems", [items]);
};

module.exports = new InAppContent();

// call the plugin as soon as deviceready fires, this makes sure the webview is loaded,
// way more solid than relying on native's pluginInitialize.
document.addEventListener('deviceready', function() {
  exec(null, null, "InAppContent", "deviceIsReady", []);
}, false);
