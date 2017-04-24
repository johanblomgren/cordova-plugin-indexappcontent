exports.defineAutoTests = function () {

    describe('Plugin', function () {
        it("should exist", function () {
            expect(window.plugins.indexAppContent).toBeDefined();
        });

        it("should offer a setItems function", function () {
            expect(window.plugins.indexAppContent.setItems).toBeDefined();
            expect(typeof window.plugins.indexAppContent.setItems == 'function').toBe(true);
        });

        it("should offer a clearItemsForDomains function", function () {
            expect(window.plugins.indexAppContent.clearItemsForDomains).toBeDefined();
            expect(typeof window.plugins.indexAppContent.clearItemsForDomains == 'function').toBe(true);
        });

        it("should offer a clearItemsForIdentifiers function", function () {
            expect(window.plugins.indexAppContent.clearItemsForIdentifiers).toBeDefined();
            expect(typeof window.plugins.indexAppContent.clearItemsForIdentifiers == 'function').toBe(true);
        });

        it("should offer a setIndexingInterval function", function () {
            expect(window.plugins.indexAppContent.setIndexingInterval).toBeDefined();
            expect(typeof window.plugins.indexAppContent.setIndexingInterval == 'function').toBe(true);
        });
    });
};

exports.defineManualTests = function (contentEl, createActionButton) {

    createActionButton('Add item', function () {
      var oItem = {
        domain: 'com.my.domain',
        identifier: '88asdf7dsf',
        title: 'Foo',
        description: 'Bar',
        url: 'http://location/of/my/image.jpg',
        keywords: ['This', 'is', 'optional'], // Item keywords (optional)
        lifetime: 1440 // Lifetime in minutes (optional)
      }
      window.plugins.indexAppContent.setItems([oItem], function() {
        console.log("Item with identifier 88asdf7dsf created");
      }, function(error) {
        console.log("error: " + error);
      })
    });

    createActionButton('Set OnItemPressed handler', function () {

      window.plugins.indexAppContent.onItemPressed = function(oItem) {
        console.log("Item with identifier " + oItem.identifier + " was invoked from spotlight search");
      }
      console.log("Javascript handler set");
      console.log("If you click on spotligh item (use manual test to create one first) then info gets logged by JS handler");
    });

    createActionButton('Clear OnItemPressed handler', function () {
      window.plugins.indexAppContent.onItemPressed = {};
      console.log("Javascript handler cleared'");
      console.log("Clicking on spotlight item will still launch the app. As soon as handler gets set then handler will be called");
    });

};
