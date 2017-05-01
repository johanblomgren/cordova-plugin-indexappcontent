var exec = require("cordova/exec");

var IndexAppContent = function () {};

IndexAppContent.prototype.init = function () {
	// TODO remove function in future release; leave it for now to ensure compatibility with older versions
};

IndexAppContent.prototype.isIndexingAvailable = function (fnCallback) {
	exec(fnCallback, undefined, "IndexAppContent", "isIndexingAvailable", []);
};

IndexAppContent.prototype.setItems = function (aItems, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!aItems || !Array.isArray(aItems)|| aItems.length===0) {
		onError("No items");
		return;
	}
	exec(onSuccess, onError, "IndexAppContent", "setItems", [aItems]);
};

IndexAppContent.prototype.clearItemsForDomains = function (aDomains, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!aDomains || !Array.isArray(aDomains) || aDomains.length===0) {
		onError("No domains");
		return;
	}
	exec(onSuccess, onError, "IndexAppContent", "clearItemsForDomains", [aDomains]);
};

IndexAppContent.prototype.clearItemsForIdentifiers = function (aIdentifiers, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!aIdentifiers || !Array.isArray(aIdentifiers) || aIdentifiers.length===0) {
		onError("No identifiers");
		return;
	}
	exec(onSuccess, onError, "IndexAppContent", "clearItemsForIdentifiers", [aIdentifiers]);
};

IndexAppContent.prototype.setIndexingInterval = function (iMinutes, onSuccess, onError) {
	if (!onError) {
		onError = function() {};
	}
	if (!Number.isInteger(iMinutes)) {
		onError("Not a number");
		return;
	}
	if (iMinutes < 0) {
		onError("Interval must => 0");
		return;
	}
	exec(onSuccess, onError, "IndexAppContent", "setIndexingInterval", [iMinutes]);
};

if (!window.plugins) {
	window.plugins = {};
}

window.plugins.indexAppContent = new IndexAppContent();

module.exports = window.plugins.indexAppContent;
