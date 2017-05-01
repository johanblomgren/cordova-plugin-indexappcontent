|Travis CI|
|:-:|
|[![Build Status](https://travis-ci.org/johanblomgren/cordova-plugin-indexappcontent.svg?branch=master)](https://travis-ci.org/johanblomgren/cordova-plugin-indexappcontent)|

## Overview
This Cordova Plugin gives you a Javascript API to interact with [Core Spotlight](https://developer.apple.com/reference/corespotlight) on iOS (=> iOS 9). You can add, update and delete items to the spotlight search index. [Spotlight](https://en.wikipedia.org/wiki/Spotlight_(software)) Search will include these items in the result list. You can deep-link the search results with your app.

## Installation
 Install using ``cordova`` CLI.
 * Run ``cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent.git``

## Usage
This plugin defines a global `window.plugins.indexAppContent` object.

### Is Indexing Available
The option to index app content might not be available at all due to device limitations or user settings. Therefore it's highly recommended to check upfront if indexing is possible.

``window.plugins.indexAppContent.isIndexingAvailable(fnCallback)`` will invoke the callback with a boolean value to indicate if indexing is possible or not.
```
window.plugins.indexAppContent.isIndexingAvailable(function(bIsAvailable){
    if (bIsAvailable === true) {
      // let's go ahead and index your content
    }
})
```

Please note that the function does not consider possible time restrictions imposed by ``setIndexingInterval``.

### Set items
Call ``window.plugins.indexAppContent.setItems(aItems, success, error)`` to add or change items to the spotlight index. Function expects at least one parameter, ``aItems``, which is an array of objects with the following structure:
```
{
    domain: 'com.my.domain',
    identifier: '88asdf7dsf',
    title: 'Foo',
    description: 'Bar',
    url: 'http://location/of/my/image.jpg',
    keywords: ['This', 'is', 'optional'], // Item keywords (optional)
    lifetime: 1440 // Lifetime in minutes (optional)
}
```

``setItems()`` also takes a success callback and a error callback (optional)

Example:

```
var aItems = [
    {
        domain: 'com.my.domain',
        identifier: '88asdf7dsf',
        title: 'Foo',
        description: 'Bar',
        url: 'http://location/of/my/image.jpg',
    },
    {
        domain: 'com.other.domain',
        identifier: '9asd67g6a',
        title: 'Baz',
        description: 'Woot',
        url: 'http://location/of/my/image2.jpg',
    }
];

window.plugins.indexAppContent.setItems(aItems, function() {
    console.log('Successfully set items');
}, function(sError) {
    console.log("Error when trying to add/modify index: " + sError);
});
```

Image data will be downloaded and stored in the background.

### On Item Pressed
If user taps on a search result in spotlight then the app will be launched. You can register a Javascript handler to get informed when this happens.

Assign a handler function to ``window.plugins.indexAppContent.onItemPressed`` that takes the payload as argument, like so:

```
window.plugins.indexAppContent.onItemPressed = function(payload) {
    console.log(payload.identifier); // Will print the identifier set on the object, see "Set items" above.
}
```

### Clear items
Call ``window.plugins.indexAppContent.clearItemsForDomains(aDomains, fnSuccess, fnError)`` to clear all items stored for a given array of domains.

Example:

```
window.plugins.indexAppContent.clearItemsForDomains(['com.my.domain', 'com.my.other.domain'], function() {
    console.log('Items removed');
}, function(sError) {
    console.log("Error when trying to clear items: " + sError);
});
```

Call ``window.plugins.indexAppContent.clearItemsForIdentifiers(aIdentifiers, fnSuccess, fnError)`` to clear all items stored for a given array of identifiers.

Example:

```
window.plugins.indexAppContent.clearItemsForIdentifiers(['id1', 'id2'], function() {
    console.log('Items removed');
}, function(sError) {
    console.log("Error when trying to clear items: " + sError);
});

```

### Set indexing interval

You might want to avoid to update spotlight index too frequently. Call ``window.plugins.indexAppContent.setIndexingInterval(iIntervalInMinutes, fnSuccess, fnError)`` to configure a time interval (in minutes) to define when indexing operations are allowed since your last spotlight index update. First parameter must be numeric and => 0.

Example:

```
window.plugins.indexAppContent.setIndexingInterval(60, function() {
    console.log('Successfully set interval');
}, function(sError) {
    console.log("Error when trying to set time interval: " + sError);
});
```

Without calling this function a subsequent call to manipulate the index is only possible after 1440 minutes (= 24 hours) !

Example:
- You call ```setIndexingInterval``` and specify 5min. You call ```setItems``` for the first time and function will be executed successfully.
- You call ```setItems``` again after 2min. Spotlight index will NOT be updated and error callback gets invoked.
- You call ```setItems``` after 6 min and function will be executed successfully.

## Tests

The plugin is covered by automatic and manual tests implemented in Jasmine and following the [Cordova test framework](https://github.com/apache/cordova-plugin-test-framework) approach.

You can create a test application with the tests by doing the following steps:

```
cordova create indexAppContentTestApp --template cordova-template-test-framework
cd indexAppContentTestApp
cordova platform add ios
cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent
cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent/tests
```

As an alternative you can use [Cordova Paramedic](https://github.com/apache/cordova-paramedic) to run them.
