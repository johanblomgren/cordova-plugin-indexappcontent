## Installation
 Install using ``cordova`` CLI.
 * Run ``cordova plugin add https://github.com/johanblomgren/cordova-plugin-indexappcontent.git``

## Usage
Plugin should be installed on ``window.plugins.indexAppContent``.

### Initialization (required)
Calling ``window.plugins.indexAppContent.init()`` will explicitly tell the native component to initialize.

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

### Set handler
Assign a handler function to ``window.plugins.indexAppContent.onItemPressed`` that takes the payload as argument, like so:

```
window.plugins.indexAppContent.onItemPressed = function(payload) {
    console.log(payload.identifier); // Will print the identifier set on the object, see "Set items" above.
}
```

This handler will be called when launching the app by pressing an item in spotlight search results.

NOTE: Set this handler before calling ``window.plugins.indexAppContent.init()``. A call to ``init()`` will tell the native code that the handler is ready to be used when the app is launched by tapping on a search result.

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

### Set indexing interval

Call ``window.plugins.indexAppContent.setIndexingInterval(interval, success, error)`` to configure the interval (in minutes) for how often indexing should be allowed.

Example:

```
window.plugins.indexAppContent.setIndexingInterval(60, function() {
        // Console.log('Successfully set interval');
    }, function(error) {
        // Handle error
    });
```
