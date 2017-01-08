//
//  ItemListDataProvider.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/17.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import UIKit

class ItemListDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    var itemManager: ItemManager?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let itemManager = itemManager else { return 0 }

        //The guard statement makes it clear that a value for the section argument can only be 0 or 1 because the Section enum only has two cases.
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }
        let numberOfRows: Int

        switch itemSection {
        case .toDo:
            numberOfRows = itemManager.toDoCount
        case .done:
            numberOfRows = itemManager.doneCount
        }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: indexPath) as! ItemCell
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: (indexPath as NSIndexPath).section) else
        {
            fatalError()
        }
        let item: ToDoItem
        switch section {
        case .toDo:
            item = itemManager.itemAtIndex((indexPath as NSIndexPath).row)
        case .done:
            item = itemManager.doneItemAtIndex((indexPath as NSIndexPath).row)
        }
        cell.configCellWithItem(item)
        return cell

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath:
        IndexPath) -> String? {
        guard let section = Section(rawValue: (indexPath as NSIndexPath).section) else
        {
            fatalError()
        }
        let buttonTitle: String
        switch section {
        case .toDo:
            buttonTitle = "Check"
        case .done:
            buttonTitle = "Uncheck"
        }
        return buttonTitle
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: (indexPath as NSIndexPath).section) else
        {
            fatalError()
        }
        switch section {
        case .toDo:
            itemManager.checkItemAtIndex((indexPath as NSIndexPath).row)
        case .done:
            itemManager.uncheckItemAtIndex((indexPath as NSIndexPath).row)
        }
        tableView.reloadData()

    }

    // chapter6
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let itemSection = Section(rawValue: (indexPath as NSIndexPath).section) else
        { fatalError() }
        switch itemSection {
        case .toDo:
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "ItemSelectedNotification"),
                object: self,
                userInfo: ["index": (indexPath as NSIndexPath).row])
        default:
            break
        }
    }
}

enum Section: Int {
    case toDo
    case done
}
