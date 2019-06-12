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
    
    func getFileURL() {
        print(realm.configuration.fileURL!)
    }
    
    func add(item: ToDoItem) {
        try! realm.write {
            realm.add(item)
        }
        delegate?.didFinishEditing()
    }
    
    func add(type: ToDoType) {
        try! realm.write {
            realm.add(type)
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
    
    
}
