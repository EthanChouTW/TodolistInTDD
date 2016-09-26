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
    private var toDoItems = [ToDoItem]()
    private var doneItems = [ToDoItem]()

    var toDoPathURL: NSURL {
        let fileURLs = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
                fatalError()
        }
        return documentURL.URLByAppendingPathComponent("toDoItems.plist")!
    }

    var donePathURL: NSURL {
        let fileURLs = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        guard let documentURL = fileURLs.first else {
            print("Something went wrong. Documents url could not be found")
            fatalError()
        }
        return documentURL.URLByAppendingPathComponent("doneItems.plist")!
    }

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

    func save() {
        //save todo
        var nsToDoItems = [AnyObject]()
        for item in toDoItems {
            nsToDoItems.append(item.plistDict)
        }
        if nsToDoItems.count > 0 {
            (nsToDoItems as NSArray).writeToURL(toDoPathURL,
                                                atomically: true)
        } else {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(toDoPathURL)
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
            (nsDoneItems as NSArray).writeToURL(donePathURL,
                                                atomically: true)
        } else {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(donePathURL)
            } catch {
                print(error)
            }
        }
    }


    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(ItemManager.save),
            name: UIApplicationWillResignActiveNotification,
            object: nil)

        // get todoItem
        if let nsToDoItems = NSArray(contentsOfURL: toDoPathURL) {
            for dict in nsToDoItems {
                if let toDoItem = ToDoItem(dict: dict as! NSDictionary) {
                    toDoItems.append(toDoItem)
                }

            }
        }

        // get doneItem
        if let nsDoneItems = NSArray(contentsOfURL: donePathURL) {
            for dict in nsDoneItems {
                if let doneItem = ToDoItem(dict: dict as! NSDictionary) {
                    doneItems.append(doneItem)
                }

            }
        }

    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        save()
    }


}
