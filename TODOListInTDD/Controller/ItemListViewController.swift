    //
//  ItemListViewController.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/17.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    // 用ItemListDataProvider不好嗎？ 可能是比較好懂，然後中間有一層
    //P85. With this change, ItemListViewController only knows about dataProvider and that it conforms to the UITableViewDataSource protocol. This means that the two classes are decoupled from each other, and there is a de ned interface in the form of the protocol.
    @IBOutlet var dataProvider: UITableViewDataSource & UITableViewDelegate & ItemManagerSettable!

    let itemManager = ItemManager()

    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager

        NotificationCenter.default.addObserver(self, selector: #selector(ItemListViewController.showDetails(_:)), name: NSNotification.Name(rawValue: "ItemSelectedNotification"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("itemManager to do count = \(itemManager.toDoCount)")
        print("itemManager to do count = \(itemManager.doneCount)")

        tableView.reloadData()

    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true,
                    completion: nil)
        }
    }



    func showDetails(_ sender: Notification) {
        guard let index = (sender as NSNotification).userInfo?["index"] as? Int else
        { fatalError() }
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }


}
// @objc原因是我們的dataprovider是在storyboard init的
@objc protocol ItemManagerSettable {
    var itemManager: ItemManager? { get set }
}

