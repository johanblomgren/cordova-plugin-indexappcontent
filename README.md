## Installation
 Install using ``cordova`` CLI.
 * Run ``cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent.git``

## Usage
Plugin should be installed on ``window.plugins.indexAppContent``.

### Set items
``window.plugins.indexAppContent.setItems(items, success, error)`` expects at least one parameter, ``items``, which is an array of objects with the following structure:
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
var items = [
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

window.plugins.indexAppContent.setItems(items, function() {
        console.log('Successfully set items');
    }, function(error) {
        // Handle error
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
Call ``window.plugins.indexAppContent.clearItemsForDomains(domains, success, error)`` to clear all items stored for a given array of domains.

Example:

```
window.plugins.indexAppContent.clearItemsForDomains(['com.my.domain', 'com.my.other.domain'], function() {
    console.log('Items removed');
    }, function(error) {
        // Handle error
    });

```

Call ``window.plugins.indexAppContent.clearItemsForIdentifiers(identifiers, success, error)`` to clear all items stored for a given array of identifiers.

Example:

```
window.plugins.indexAppContent.clearItemsForIdentifiers(['id1', 'id2'], function() {
    console.log('Items removed');
    }, function(error) {
        // Handle error
    });

```

### Set indexing interval

Call ``window.plugins.indexAppContent.setIndexingInterval(interval, success, error)`` to configure the interval (in minutes) for how often indexing should be allowed. First parameter must be numeric and => 0.

Example:

```
window.plugins.indexAppContent.setIndexingInterval(60, function() {
        // Console.log('Successfully set interval');
    }, function(error) {
        // Handle error
    });
```

## Tests

The plugin is covered by automatic and manual tests implemented in Jasmine and following the [Cordova test framework](https://github.com/apache/cordova-plugin-test-framework) approach.

You can create a test application and install the tests by doing the following steps:

```
cordova create indexAppContentTestApp --template cordova-template-test-framework
cd indexAppContentTestApp
cordova platform add ios
cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent
cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent/tests
```
