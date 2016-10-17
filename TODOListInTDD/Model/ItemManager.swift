//
//  ItemManager.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/16.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import UIKit

class ItemManager: NSObject {
    var toDoCount: Int { return toDoItems.count}
    var doneCount: Int { return doneItems.count}
    fileprivate var toDoItems = [ToDoItem]()
    fileprivate var doneItems = [ToDoItem]()

    var toDoPathURL: URL {
        let fileURLs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
                fatalError()
        }
        return documentURL.appendingPathComponent("toDoItems.plist")
    }

    var donePathURL: URL {
        let fileURLs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        return documentURL.appendingPathComponent("doneItems.plist")
    }

    func addItem(_ item: ToDoItem) {

        if !toDoItems.contains(item) {
            toDoItems.append(item)
        }
    }

    func itemAtIndex(_ index: Int) -> ToDoItem {

        return  toDoItems[index]
    }

    func checkItemAtIndex(_ index: Int) {
        
        let item = toDoItems.remove(at: index)
        doneItems.append(item)
    }

    func doneItemAtIndex(_ index: Int) -> ToDoItem {
        return doneItems[index]
    }

    func removeAllItems() {
        toDoItems.removeAll()
        doneItems.removeAll()
    }

    func uncheckItemAtIndex(_ index: Int) {
        let item = doneItems.remove(at: index)
        toDoItems.append(item)
    }

    func save() {
        //save todo
        var nsToDoItems = [AnyObject]()
        for item in toDoItems {
            nsToDoItems.append(item.plistDict)
        }
        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).write(to: toDoPathURL,
                                                atomically: true)
        } else {
            do {
                try FileManager.default.removeItem(at: toDoPathURL)
            } catch {
                print(error)
            }
        }

        // save done
        var nsDoneItems = [AnyObject]()
        for item in doneItems {
            nsDoneItems.append(item.plistDict)
        }

        if nsDoneItems.count > 0 {
            (nsDoneItems as NSArray).write(to: donePathURL,
                                                atomically: true)
        } else {
            do {
                try FileManager.default.removeItem(at: donePathURL)
            } catch {
                print(error)
            }
        }
    }


    override init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ItemManager.save),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil)

        // get todoItem
        if let nsToDoItems = NSArray(contentsOf: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary) {
                    toDoItems.append(toDoItem)
                }

            }
        }

        // get doneItem
        if let nsDoneItems = NSArray(contentsOf: donePathURL) {
            for dict in nsDoneItems {
                if let doneItem = ToDoItem(dict: dict as! NSDictionary) {
                    doneItems.append(doneItem)
                }

            }
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        save()
    }


}
