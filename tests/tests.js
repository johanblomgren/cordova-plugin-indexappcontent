/* jshint jasmine: true */
exports.defineAutoTests = function() {

    describe('Plugin', function() {
        it("should exist", function() {
            expect(window.plugins.indexAppContent).toBeDefined();
        });

        it("should offer a setItems function", function() {
            expect(window.plugins.indexAppContent.setItems).toBeDefined();
            expect(typeof window.plugins.indexAppContent.setItems == 'function').toBe(true);
        });

        it("should offer a clearItemsForDomains function", function() {
            expect(window.plugins.indexAppContent.clearItemsForDomains).toBeDefined();
            expect(typeof window.plugins.indexAppContent.clearItemsForDomains == 'function').toBe(true);
        });

        it("should offer a clearItemsForIdentifiers function", function() {
            expect(window.plugins.indexAppContent.clearItemsForIdentifiers).toBeDefined();
            expect(typeof window.plugins.indexAppContent.clearItemsForIdentifiers == 'function').toBe(true);
        });

        it("should offer a setIndexingInterval function", function() {
            expect(window.plugins.indexAppContent.setIndexingInterval).toBeDefined();
            expect(typeof window.plugins.indexAppContent.setIndexingInterval == 'function').toBe(true);
        });
    });

    describe('setItems', function() {

        it("shall not harm when calling without any parameters", function() {
            window.plugins.indexAppContent.setItems();
            expect("noJsError").toBeTruthy();
        });

        it("shall invoke error callback in case of no input", function(done) {
            window.plugins.indexAppContent.setItems(undefined, function() {
                done.fail();
            }, function(error) {
                expect(error.message).toBe("No items");
                done();
            });

        });

        it("shall invoke error callback in case of incorrect input", function(done) {
            window.plugins.indexAppContent.setItems("No Array with Item", function() {
                done.fail();
            }, function(error) {
                expect(error.message).toBe("No items");
                done();
            });
        });
    });

    describe('clearItemsForDomains', function() {

        it("shall not harm when calling without any parameters", function() {
            window.plugins.indexAppContent.clearItemsForDomains();
            expect("noJsError").toBeTruthy();
        });

        it("shall invoke error callback in case of no input", function(done) {
            window.plugins.indexAppContent.clearItemsForDomains(undefined, function() {
                done.fail();
            }, function(error) {
                expect(error.message).toBe("No domains");
                done();
            });

        });

        it("shall invoke error callback in case of incorrect input", function(done) {
            window.plugins.indexAppContent.clearItemsForDomains("No Array with domains", function() {
                done.fail();
            }, function(error) {
                expect(error.message).toBe("No domains");
                done();
            });
        });
    });

    describe('clearItemsForIdentifiers', function() {

        it("shall not harm when calling without any parameters", function() {
            window.plugins.indexAppContent.clearItemsForIdentifiers();
            expect("noJsError").toBeTruthy();
        });

        it("shall invoke error callback in case of no input", function(done) {
            window.plugins.indexAppContent.clearItemsForIdentifiers(undefined, function() {
                done.fail();
            }, function(error) {
                expect(error.message).toBe("No identifiers");
                done();
            });

        });

        it("shall invoke error callback in case of incorrect input", function(done) {
            window.plugins.indexAppContent.clearItemsForIdentifiers("No Array with identifiers", function() {
                done.fail();
            }, function(error) {
                expect(error.message).toBe("No identifiers");
                done();
            });
        });
    });

    describe('setIndexingInterval', function() {

        it("shall not harm when calling without any parameters", function() {
            window.plugins.indexAppContent.setIndexingInterval();
            expect("noJsError").toBeTruthy();
        });

        it("shall invoke error callback in case of values < 0", function(done) {
            window.plugins.indexAppContent.setIndexingInterval(-1, function() {
                done.fail();
            }, function(oError) {
                expect(oError).toBeDefined();
                done();
            });
        });

        it("shall accept 0 as value and invoke success callback", function(done) {
            window.plugins.indexAppContent.setIndexingInterval(0, function() {
                expect("success").toBeTruthy();
                done();
            }, function() {
                done.fail();
            });
        });

        it("shall accept values > 0 and invoke success callback", function(done) {
            window.plugins.indexAppContent.setIndexingInterval(77, function() {
                expect("success").toBeTruthy();
                done();
            }, function() {
                done.fail();
            });
        });
    });

    describe('Integration test', function() {

        it("shall perform basic sequence of calls", function(done) {

            var fnCreateAndDelete = function() {
                var oItem = {
                    domain: 'com.my.domain',
                    identifier: '88asdf7dsf',
                    title: 'Foo',
                    description: 'Bar',
                    url: 'http://location/of/my/image.jpg',
                    keywords: ['This', 'is', 'optional'], // Item keywords (optional)
                    lifetime: 1440 // Lifetime in minutes (optional)
                };
                window.plugins.indexAppContent.setItems([oItem], function() {
                    window.plugins.indexAppContent.clearItemsForDomains(['com.my.domain'], function() {
                        expect("everythingSeemsToWork").toBeTruthy();
                        done();
                    }, function() {
                        done.fail();
                    });
                }, function(error) {
                    done.fail();
                });
            };

            window.plugins.indexAppContent.setIndexingInterval(0, function() {
                window.plugins.indexAppContent.clearItemsForIdentifiers(['88asdf7dsf'], function() {
                    fnCreateAndDelete();
                }, function() {
                    fnCreateAndDelete();
                });
            }, function(error) {
                done.fail();
            });
        });
    });
};

exports.defineManualTests = function(contentEl, createActionButton) {

    createActionButton('Add item', function() {
        var oItem = {
            domain: 'com.my.domain',
            identifier: '88asdf7dsf',
            title: 'Foo',
            description: 'Bar',
            url: 'http://location/of/my/image.jpg',
            keywords: ['This', 'is', 'optional'], // Item keywords (optional)
            lifetime: 1440 // Lifetime in minutes (optional)
        };
        window.plugins.indexAppContent.setItems([oItem], function() {
            console.log("Item with identifier 88asdf7dsf created");
        }, function(error) {
            console.log("error: " + error);
        });
    });

    createActionButton('Set OnItemPressed handler', function() {

        window.plugins.indexAppContent.onItemPressed = function(oItem) {
            console.log("Item with identifier " + oItem.identifier + " was invoked from spotlight search");
        };
        console.log("Javascript handler set");
        console.log("If you click on spotligh item (use manual test to create one first) then info gets logged by JS handler");
    });

    createActionButton('Clear OnItemPressed handler', function() {
        window.plugins.indexAppContent.onItemPressed = {};
        console.log("Javascript handler cleared'");
        console.log("Clicking on spotlight item will still launch the app. As soon as handler gets set then handler will be called");
    });

};
