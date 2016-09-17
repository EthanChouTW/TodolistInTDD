//
//  ItemCellTestss.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/18.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
@testable import TODOListInTDD

class ItemCellTestss: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSUT_HasNameLabel() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewControllerWithIdentifier(
            "ItemListViewController") as! ItemListViewController
        _ = controller.view
        let tableView = controller.tableView
        let dataSource = FakeDataSource()
        tableView.dataSource = dataSource

        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: NSIndexPath(forRow: 0, inSection: 0)) as! ItemCell

        XCTAssertNotNil(cell.titleLabel)
    }
    
}


extension ItemCellTestss {
    class FakeDataSource: NSObject, UITableViewDataSource {
        weak var tableView: UITableView!

        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

                return UITableViewCell()
        }
    }
}