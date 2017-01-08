//
//  ItemManagerTests.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/16.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
@testable import TODOListInTDD
import CoreLocation


class ItemManagerTests: XCTestCase {
    var sut: ItemManager!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ItemManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.removeAllItems()
        sut = nil
        super.tearDown()
    }

    func testToDoCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.toDoCount, 0,
                       "Initially toDo count should be 0")
    }

    func testDoneCount_Initially_ShouldBeZero() {
        XCTAssertEqual(sut.doneCount, 0,
                       "Initially done count should be 0")
    }

    func testToDoCount_AfterAddingOneItem_IsOne() {
        sut.addItem(ToDoItem(title: "Test title"))
        XCTAssertEqual(sut.toDoCount, 1, "toDoCount should be 1")
    }

    func testItemAtIndex_ShouldReturnPreviouslyAddedItem() {
        let item = ToDoItem(title: "Item")
        sut.addItem(item)
        let returnedItem = sut.itemAtIndex(0)

        XCTAssertEqual(item.title, returnedItem.title,
                       "should be the same item")
    }


    func testCheckingItem_ChangesCountOfToDoAndOfDoneItems() {
        sut.addItem(ToDoItem(title: "First Item"))
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 1, "doneCount should be 1")
    }

    func testCheckingItem_RemovesItFromTheToDoItemList() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "Second")
        sut.addItem(firstItem)
        sut.addItem(secondItem)
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.itemAtIndex(0).title, secondItem.title)
    }

    func testDoneItemAtIndex_ShouldReturnPreviouslyCheckedItem() {
        let item = ToDoItem(title: "Item")
        sut.addItem(item)
        sut.checkItemAtIndex(0)
        let returnedItem = sut.doneItemAtIndex(0)

        XCTAssertEqual(item.title, returnedItem.title,
                       "should be the same item")
    }


    //we can't see item.title equal to returnedItem.title as item equal to returnedItem so make item conformed equalable protocol
    func testEqualItems_ShouldBeEqual() {
        let firstItem = ToDoItem(title: "First")
        let secondItem = ToDoItem(title: "First")
        XCTAssertEqual(firstItem, secondItem)
    }

    func testWhenLocationDifferes_ShouldBeNotEqual() {
        let firstItem =
            ToDoItem(title: "First title",
                     itemDescription: "First description",
                     timestamp: 0.0,
                     location: Location(name: "Home"))

        let secondItem =
            ToDoItem(title: "First title",
                     itemDescription: "First description",
                     timestamp: 0.0,
                     location: Location(name: "Office"))

        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testEqualLocations_ShouldBeEqual() {
        let firstLocation = Location(name: "Home")
        let secondLoacation = Location(name: "Home")
        XCTAssertEqual(firstLocation, secondLoacation)
    }

    func testWhenLatitudeDifferes_ShouldBeNotEqual() {
        performNotEqualTestWithLocationProperties("Home",secondName: "Home",
            firstLongLat: (1.0, 0.0),
            secondLongLat: (0.0, 0.0))

    }

    func testWhenLongitudeDifferes_ShouldBeNotEqual() {
        performNotEqualTestWithLocationProperties("Home",secondName: "Home",firstLongLat: (0.0, 1.0),secondLongLat: (0.0, 0.0))

    }

    func performNotEqualTestWithLocationProperties(_ firstName: String, secondName: String, firstLongLat: (Double, Double)?, secondLongLat: (Double, Double)?, line: UInt =  #line ) {

        let firstCoord: CLLocationCoordinate2D?
        if let firstLongLat = firstLongLat {
            firstCoord = CLLocationCoordinate2D(
                latitude: firstLongLat.0,
                longitude: firstLongLat.1)
        } else {
            firstCoord = nil
        }

        let firstLocation =
            Location(name: firstName,
                     coordinate: firstCoord)

        let secondCoord: CLLocationCoordinate2D?
        if let secondLongLat = secondLongLat {
            secondCoord = CLLocationCoordinate2D(
                latitude: secondLongLat.0,
                longitude: secondLongLat.1)
        } else {
            secondCoord = nil
        }
        let secondLocation =
            Location(name: secondName,
                     coordinate: secondCoord)
        XCTAssertNotEqual(firstLocation, secondLocation, line: line)
    }

    func testWhenOneHasCoordinateAndTheOtherDoesnt_ShouldBeNotEqual() {
        performNotEqualTestWithLocationProperties("Home",secondName: "Home",firstLongLat: (0.0, 0.0),secondLongLat: nil)
    }

    func testWhenNameDifferes_ShouldBeNotEqual() {
        performNotEqualTestWithLocationProperties("Home",secondName: "Office",firstLongLat: nil,secondLongLat: nil)
    }

    func testWhenOneLocationIsNilAndTheOtherIsnt_ShouldBeNotEqual() {
        var firstItem = ToDoItem(title: "First title",
                                 itemDescription: "First description",
                                 timestamp: 0.0,
                                 location: nil)
        var secondItem = ToDoItem(title: "First title",
                                  itemDescription: "First description",
                                  timestamp: 0.0,
                                  location: Location(name: "Office"))
        XCTAssertNotEqual(firstItem, secondItem)

        firstItem = ToDoItem(title: "First title",
                             itemDescription: "First description",
                             timestamp: 0.0,
                             location: Location(name: "Home"))
        secondItem = ToDoItem(title: "First title",
                              itemDescription: "First description",
                              timestamp: 0.0,
                              location: nil)
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenTimestampDifferes_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title",
                                 itemDescription: "First description",
                                 timestamp: 1.0)
        let secondItem = ToDoItem(title: "First title",
                                  itemDescription: "First description",
                                  timestamp: 0.0)
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenDescriptionDifferes_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title",
                                 itemDescription: "First description")
        let secondItem = ToDoItem(title: "First title",
                                  itemDescription: "Second description")
        XCTAssertNotEqual(firstItem, secondItem)
    }

    func testWhenTitleDifferes_ShouldBeNotEqual() {
        let firstItem = ToDoItem(title: "First title")
        let secondItem = ToDoItem(title: "Second title")
        XCTAssertNotEqual(firstItem, secondItem)
    }


    func testRemoveAllItems_ShouldResultInCountsBeZero() {
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "Second"))
        sut.checkItemAtIndex(0)
        XCTAssertEqual(sut.toDoCount, 1,
                       "toDoCount should be 1")
        XCTAssertEqual(sut.doneCount, 1,
                       "doneCount should be 1")
        sut.removeAllItems()
        XCTAssertEqual(sut.toDoCount, 0, "toDoCount should be 0")
        XCTAssertEqual(sut.doneCount, 0, "doneCount should be 0")

    }

    func testAddingTheSameItem_DoesNotIncreaseCount() {
        // so if toDoItem is type of class, this may lead to not Equal, right? no, because Equatable protocol we do only tell title equality.
        sut.addItem(ToDoItem(title: "First"))
        sut.addItem(ToDoItem(title: "First"))
        XCTAssertEqual(sut.toDoCount, 1)
    }

    // check if write to disk
    func test_ToDoItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager!.addItem(firstItem)
        let secondItem = ToDoItem(title: "Second")
        itemManager!.addItem(secondItem)
        NotificationCenter.default.post(
            name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        itemManager = nil
        XCTAssertNil(itemManager)
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 2)
        XCTAssertEqual(itemManager?.itemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(1), secondItem)
    }

    func test_DoneItemsGetSerialized() {
        var itemManager: ItemManager? = ItemManager()
        let firstItem = ToDoItem(title: "First")
        itemManager!.addItem(firstItem)
        let secondItem = ToDoItem(title: "Second")
        itemManager!.addItem(secondItem)
        itemManager!.checkItemAtIndex(0)
        NotificationCenter.default.post(
            name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        itemManager = nil
        XCTAssertNil(itemManager)
        itemManager = ItemManager()
        XCTAssertEqual(itemManager?.toDoCount, 1)
        XCTAssertEqual(itemManager?.doneCount, 1)
        XCTAssertEqual(itemManager?.doneItemAtIndex(0), firstItem)
        XCTAssertEqual(itemManager?.itemAtIndex(0), secondItem)
    }
}
