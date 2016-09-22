//
//  TODOListInTDDUITests.swift
//  TODOListInTDDUITests
//
//  Created by pp1285 on 2016/9/22.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest

class TODOListInTDDUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        
//        let app = XCUIApplication()
//        app.navigationBars["TODOListInTDD.ItemListView"].buttons["Add"].tap()
//        app.textFields["title"].tap()
//        
//        let shiftButton = app.buttons["shift"]
//        shiftButton.tap()
//        app.textFields["title"]
//        app.textFields["date"].tap()
//        
//        let moreNumbersKey = app.keys["more, numbers"]
//        moreNumbersKey.tap()
//        app.textFields["date"]
//        
//        let deleteKey = app.keys["delete"]
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        app.textFields["date"]
//        app.textFields["location"].tap()
//        shiftButton.tap()
//        app.textFields["location"]
//        app.textFields["address"].tap()
//        shiftButton.tap()
//        app.textFields["address"]
//        shiftButton.tap()
//        app.textFields["address"]
//        moreNumbersKey.tap()
//        moreNumbersKey.tap()
//        app.textFields["address"]
//        shiftButton.tap()
//        app.textFields["address"]
//        app.textFields["description"].tap()
//        shiftButton.tap()
//        app.textFields["description"]
//        shiftButton.tap()
//        app.textFields["description"]
//        app.buttons["Save"].tap()

        let app = XCUIApplication()
        app.navigationBars["TODOListInTDD.ItemListView"].buttons["Add"].tap()
        let titleTextField = app.textFields["title"]
        titleTextField.tap()
        titleTextField.typeText("Meeting")
        let dateTextField = app.textFields["date"]
        dateTextField.tap()
        dateTextField.typeText("02/22/2016")
        let locationNameTextField = app.textFields["location"]
        locationNameTextField.tap()
        locationNameTextField.typeText("Office")
        let addressTextField = app.textFields["address"]
        addressTextField.tap()
        addressTextField.typeText("Infinite Loop 1, Cupertino")
        let descriptionTextField = app.textFields["description"]
        descriptionTextField.tap()
        descriptionTextField.typeText("Bring iPad")
        app.buttons["Save"].tap()

        XCTAssertTrue(app.tables.staticTexts["Meeting"].exists)
        XCTAssertTrue(app.tables.staticTexts["02/22/2016"].exists)
        XCTAssertTrue(app.tables.staticTexts["Office"].exists)


    }
    
}
