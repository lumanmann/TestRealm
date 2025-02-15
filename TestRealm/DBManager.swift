//
//  DBManager.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/12.
//  Copyright © 2019 appi. All rights reserved.
//

import Foundation
import RealmSwift

class DBManager {
    static var shared = DBManager()

    var notificationToken: NotificationToken?
    lazy var realm = try! Realm()
    
    var todos: Results<ToDoItem> {
        get {
            return realm.objects(ToDoItem.self)
        }
    }
    
    var pepeole: Results<Person> {
        get {
            return realm.objects(Person.self)
        }
    }
    
    private init() {}
    
    func getFileURL() {
        print(realm.configuration.fileURL!)
    }
    
    
    
    func startNotification(_ handler: @escaping (()->Void)) {
        notificationToken = self.realm.observe {
             (notification, realm) in
            handler()

        }
        
    }
    
    func stopNotification() {
        if let token = notificationToken {
            token.invalidate()
        }
       
    }
    
    func add(item: ToDoItem, owner: Person) {
        item.owner = owner
        append(item: item, to: owner)
        
        try! realm.write {
            realm.add(item)
        }
       
    }
    
    func add(owner: Person) {
        owner.id = pepeole.count 
        try! realm.write {
            realm.add(owner)
        }
    }
    
    func delete(item: ToDoItem) {
      
        try! realm.write {
            realm.delete(item)
        }
        
    }
    
    func append(item: ToDoItem, to owner: Person) {
        try! realm.write {
            owner.toDoItem.append(item)
        }
    }
    
    func deleteAll() {
        try? realm.write {
            realm.deleteAll()
        }

    }
    
   
    func setIsDone(item: ToDoItem) {
        try! realm.write {
            item.isDone = !item.isDone
        }
    }
    
    func filterItem(name: String) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "name CONTAINS %@", name)
        let items = realm.objects(ToDoItem.self).filter(predicate)
        return items
    }
    
    func filterItem(isDone: Bool) -> Results<ToDoItem>  {
        let predicate = NSPredicate(format: "isDone = '\(isDone)'")
        let items = realm.objects(ToDoItem.self).filter(predicate)
        return items
    }
    
    func filterItem(owner: String) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "owner.name CONTAINS %@", owner)
    
        let items = realm.objects(ToDoItem.self).filter(predicate)
       
        return items
    }
    
    func filterItem(type: String) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "type CONTAINS %@", type)
        let items = realm.objects(ToDoItem.self).filter(predicate)
        return items
    }
    
    func filterItem(deadlineBefore: NSDate) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "deadline < %@", deadlineBefore)
        let items = realm.objects(ToDoItem.self).filter(predicate)
        return items
    }

    func filterOwner(name: String) -> Results<Person>  {
        let predicate = NSPredicate(format: "owner.name CONTAINS %@", name)
        let owners = realm.objects(Person.self).filter(predicate)
        return owners
    }
    
}
