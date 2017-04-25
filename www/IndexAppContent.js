var exec = require("cordova/exec");

var IndexAppContent = function () {};

IndexAppContent.prototype.init = function () {
	// TODO remove function in future release; leave it for now to ensure compatibility with older versions
};

IndexAppContent.prototype.setItems = function (items, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!items || !Array.isArray(items)|| items.length==0) {
		onError(new Error("No items"));
		return;
	}
	exec(onSuccess, onError, "IndexAppContent", "setItems", [items]);
};

IndexAppContent.prototype.clearItemsForDomains = function (domains, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!domains || !Array.isArray(domains) || domains.length==0) {
		onError(new Error("No domains"));
		return;
	}
	exec(onSuccess, onError, "IndexAppContent", "clearItemsForDomains", [domains]);
};

IndexAppContent.prototype.clearItemsForIdentifiers = function (identifiers, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!identifiers || !Array.isArray(identifiers) || domains.length==0) {
		onError(new Error("No identifiers"));
		return;
	}
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
