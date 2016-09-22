//
//  ItemCellTestss.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/18.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
@testable import TODOListInTDD

// 書上有一個小bug
//http://stackoverflow.com/questions/38719436/caught-nsinternalinconsistencyexception-request-for-rect-at-invalid-indexpath/39065149#39065149

class ItemCellTestss: XCTestCase {
    weak var tableView: UITableView!
    var dataSource: UITableViewDataSource!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(
            "ItemListViewController") as! ItemListViewController
        _ = controller.view
        tableView = controller.tableView
         // 要生成instance才能做source
        dataSource = FakeDataSource()
        tableView.dataSource = dataSource


    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_HasNameLabel() {


        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell

        XCTAssertNotNil(cell.titleLabel)
    }

    func testSUT_HasLocationLabel() {

        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        XCTAssertNotNil(cell.locationLabel)
    }

    func testSUT_HasDescriptionLabel() {

        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        XCTAssertNotNil(cell.dateLabel)
    }

    func testConfigWithItem_SetsLabelTexts() {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "ItemCell",
            forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as!
        ItemCell
        cell.configCellWithItem(ToDoItem(title: "First", itemDescription:
            nil, timestamp: 1456150025, location: Location(name: "Home")))
        XCTAssertEqual(cell.titleLabel.text, "First")
        XCTAssertEqual(cell.locationLabel.text, "Home")
        XCTAssertEqual(cell.dateLabel.text, "02/22/2016")
    }

    func testTitle_ForCheckedTasks_IsStrokeThrough() {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "ItemCell",forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell
        let toDoItem = ToDoItem(title: "First",
                                itemDescription: nil,
                                timestamp: 1456150025,
                                location: Location(name: "Home"))
        cell.configCellWithItem(toDoItem, checked: true)
        let attributedString = NSAttributedString(string: "First",
                                                  attributes: [NSStrikethroughStyleAttributeName:
                                                    NSUnderlineStyle.StyleSingle.rawValue])
        XCTAssertEqual(cell.titleLabel.attributedText, attributedString)
        XCTAssertNil(cell.locationLabel.text)
        XCTAssertNil(cell.dateLabel.text)
    }

    
}


extension ItemCellTestss {
    class FakeDataSource: NSObject, UITableViewDataSource {


        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

                return UITableViewCell()
        }
    }
}