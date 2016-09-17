//
//  ItemManager.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/16.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import Foundation

class ItemManager {
    var toDoCount: Int { return toDoItems.count}
    var doneCount: Int { return doneItems.count}
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

    func addItem(item: ToDoItem) {

        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }

    func itemAtIndex(index: Int) -> ToDoItem {

        return  toDoItems[index]
    }

    func checkItemAtIndex(index: Int) {
        
        let item = toDoItems.removeAtIndex(index)
        doneItems.append(item)
    }

    func doneItemAtIndex(index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }

    func uncheckItemAtIndex(index: Int) {
        let item = doneItems.removeAtIndex(index)
        toDoItems.append(item)
    }


}