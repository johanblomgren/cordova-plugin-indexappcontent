var exec = require("cordova/exec");

var IndexAppContent = function () {
};

IndexAppContent.prototype.setItems = function (items, onSuccess, onError) {
  exec(onSuccess, onError, "IndexAppContent", "setItems", [items]);
};

module.exports = new IndexAppContent();

// call the plugin as soon as deviceready fires, this makes sure the webview is loaded,
// way more solid than relying on native's pluginInitialize.
document.addEventListener('deviceready', function() {
  exec(null, null, "IndexAppContent", "deviceIsReady", []);
}, false);
