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
    @IBOutlet var dataProvider: protocol<UITableViewDataSource,
    UITableViewDelegate>!

    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
}
