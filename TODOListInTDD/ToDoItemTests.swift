//
//  ToDoItemTests.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/16.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
@testable import TODOListInTDD
class ToDoItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_ShouldSetTitle() {
        let item = ToDoItem(title: "Test title")
        XCTAssertEqual(item.title, "Test title", "Initializer should set the item title")
    }

    func testInit_ShouldTakeTitleAndDescription() {
        let item = ToDoItem(title: "Test title",itemDescription: "Test description")
        XCTAssertEqual(item.itemDescription , "Test description", "Initializer should set the item description")
    }

    func testInit_ShouldSetTitleAndDescriptionAndTimestamp() {
        let item = ToDoItem(title: "Test title",
                            itemDescription: "Test description",
                            timestamp: 0.0)
        XCTAssertEqual(0.0, item.timestamp,
                       "Initializer should set the timestamp")
    }

    func testInit_ShouldTakeTitleAndDescriptionAndTimestampAndLocation() {
        let location = Location(name: "Test name")
        let item = ToDoItem(title: "Test title",
                            itemDescription: "Test description",
                            timestamp: 0.0,
                            location: location)
        XCTAssertEqual(location.name, item.location?.name,
                       "Initializer should set the location")
    }

    // chapter6
    func test_HasPlistDictionaryProperty() {
        let item = ToDoItem(title: "First")
        let dictionary = item.plistDict
        XCTAssertNotNil(dictionary)
        XCTAssertTrue(dictionary is NSDictionary)

    }

    func test_CanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Home")
        let item = ToDoItem(title: "The Title",
                            itemDescription: "The Description",
                            timestamp: 1.0,
                            location: location)
        let dict = item.plistDict
        let recreatedItem = ToDoItem(dict: dict)
        XCTAssertEqual(item, recreatedItem)
    }
}
