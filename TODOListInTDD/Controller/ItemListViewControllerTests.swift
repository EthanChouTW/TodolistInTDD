//
//  ItemListViewControllerTests.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/17.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
@testable import TODOListInTDD


class ItemListViewControllerTests: XCTestCase {
    var sut: ItemListViewController!
    var inputViewController: InputViewController!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = sut.view

        //chaptor 6 put it all together
        UIApplication.shared.keyWindow?.rootViewController = sut
        // 確定沒被presented 過
        XCTAssertNil(sut.presentedViewController)
        guard let addButton = sut.navigationItem.rightBarButtonItem else
        { XCTFail(); return }
        sut.perform(addButton.action, with: addButton)
        XCTAssertNotNil(sut.presentedViewController)
        XCTAssertTrue(sut.presentedViewController is InputViewController)
        inputViewController = sut.presentedViewController as! InputViewController


    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_TableViewIsNotNilAfterViewDidLoad() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let sut = storyboard.instantiateViewControllerWithIdentifier("ItemListViewController") as! ItemListViewController
//        _ = sut.view
        XCTAssertNotNil(sut.tableView)
    }

    func testViewDidLoad_ShouldSetTableViewDataSource() {
                    XCTAssertNotNil(sut.tableView.dataSource)
            XCTAssertTrue(sut.tableView.dataSource is ItemListDataProvider)
    }
    func testViewDidLoad_ShouldSetTableViewDelegate() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertTrue(sut.tableView.delegate is ItemListDataProvider)
    }

    func testViewDidLoad_ShouldSetDelegateAndDataSourceToTheSameObject() {
        
        XCTAssertEqual(sut.tableView.dataSource as? ItemListDataProvider,
                       sut.tableView.delegate as? ItemListDataProvider)
    }

    // chapter6 put it all together
    func testItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem?.target as?
            UIViewController, sut)
    }

    func testAddItem_PresentsAddItemViewController() {

        XCTAssertNotNil(inputViewController.titleTextField)
    }




    func testItemListVC_SharesItemManagerWithInputVC() {

        guard let inputItemManager = inputViewController.itemManager else { XCTFail(); return }
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }

    // to link itemManager made to tableViewDataSource
    func testViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }

    func test_reloadedTableView() {

        ///////  從這裡
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = sut.view
        ///////  到這裡，雖然setup有寫了，但一定要加，我不知道為何.......

        let mockTableView = MockTableView()
        sut.tableView = mockTableView

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertTrue(mockTableView.reloadDataGotCalled)
    }


    func testItemSelectedNotification_PushesDetailVC() {

        /////
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        _ = sut.view
        ///// 我也不知道為何要重新initiate，書上的方法沒這樣寫就fail

        let mockNavigationController = MockNavigationController(rootViewController: sut)

        UIApplication.shared.keyWindow?.rootViewController =
        mockNavigationController

    NotificationCenter.default.post(name: Notification.Name(rawValue: "ItemSelectedNotification"), object: sut.dataProvider, userInfo: ["index": 1])
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else { XCTFail(); return
        }

        guard let detailItemManager = detailViewController.itemInfo?.0
            else { XCTFail(); return }
        guard let index = detailViewController.itemInfo?.1 else { XCTFail(); return }
        _ = detailViewController.view

        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)


    }

}

extension ItemListViewControllerTests {

    class MockTableView: UITableView {
        var reloadDataGotCalled = false
         override func reloadData() {
            super.reloadData()
            reloadDataGotCalled = true
        }

    }

    class MockNavigationController : UINavigationController {
        var pushedViewController: UIViewController?
        override func pushViewController(_ viewController:UIViewController,animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
