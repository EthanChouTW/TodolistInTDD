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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let itemManager = itemManager else { return 0 }

        //The guard statement makes it clear that a value for the section argument can only be 0 or 1 because the Section enum only has two cases.
        guard let itemSection = Section(rawValue: section) else {
            fatalError()
        }
        let numberOfRows: Int

        switch itemSection {
        case .ToDo:
            numberOfRows = itemManager.toDoCount
        case .Done:
            numberOfRows = itemManager.doneCount
        }
        return numberOfRows
    }

    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "ItemCell",
            forIndexPath: indexPath) as! ItemCell
        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError()
        }
        let item: ToDoItem
        switch section {
        case .ToDo:
            item = itemManager.itemAtIndex(indexPath.row)
        case .Done:
            item = itemManager.doneItemAtIndex(indexPath.row)
        }
        cell.configCellWithItem(item)
        return cell

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAtIndexPath indexPath:
        NSIndexPath) -> String? {
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError()
        }
        let buttonTitle: String
        switch section {
        case .ToDo:
            buttonTitle = "Check"
        case .Done:
            buttonTitle = "Uncheck"
        }
        return buttonTitle
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        guard let itemManager = itemManager else { fatalError() }
        guard let section = Section(rawValue: indexPath.section) else
        {
            fatalError()
        }
        switch section {
        case .ToDo:
            itemManager.checkItemAtIndex(indexPath.row)
        case .Done:
            itemManager.uncheckItemAtIndex(indexPath.row)
        }
        tableView.reloadData()

    }

}

enum Section: Int {
    case ToDo
    case Done
}