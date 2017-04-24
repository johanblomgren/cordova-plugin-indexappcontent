var exec = require("cordova/exec");

var IndexAppContent = function () {};

IndexAppContent.prototype.init = function () {
	// TODO remove function in future release; leave it for now to ensure compatibility with older versions
};

IndexAppContent.prototype.setItems = function (items, onSuccess, onError) {
	exec(onSuccess, onError, "IndexAppContent", "setItems", [items]);
};

IndexAppContent.prototype.clearItemsForDomains = function (domains, onSuccess, onError) {
	exec(onSuccess, onError, "IndexAppContent", "clearItemsForDomains", [domains]);
};

IndexAppContent.prototype.clearItemsForIdentifiers = function (identifiers, onSuccess, onError) {
	exec(onSuccess, onError, "IndexAppContent", "clearItemsForIdentifiers", [identifiers]);
};

IndexAppContent.prototype.setIndexingInterval = function (interval, onSuccess, onError) {
	exec(onSuccess, onError, "IndexAppContent", "setIndexingInterval", [interval]);
};

if (!window.plugins) {
	window.plugins = {};
}

window.plugins.indexAppContent = new IndexAppContent();

module.exports = window.plugins.indexAppContent;
