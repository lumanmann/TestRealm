//
//  DBManager.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/12.
//  Copyright © 2019 appi. All rights reserved.
//

import Foundation
import RealmSwift

protocol DBManagerDelegate: class {
    func didFinishEditing()
    
}

class DBManager {
    static var shared = DBManager()
    
    private init() {}
    
    
    lazy var realm = try! Realm()
    weak var delegate: DBManagerDelegate?
    
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
    
    func getFileURL() {
        print(realm.configuration.fileURL!)
    }
    
    func add(item: ToDoItem) {
        try! realm.write {
            realm.add(item)
        }
        delegate?.didFinishEditing()
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
    
    func deleteAll() {
        try? realm.write {
            realm.deleteAll()
        }
        delegate?.didFinishEditing()
    }
    
   
    func setIsDone(item: ToDoItem) {
        try! realm.write {
            item.isDone = !item.isDone
        }
    }
    
    func filterItem(name: String) -> Results<ToDoItem> {
        let predicate = NSPredicate(format: "owner.name CONTAINS %@", name)
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
    

    
    func filterOwner(name: String) {
        
    }
    
}
