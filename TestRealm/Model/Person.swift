//
//  Person.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/13.
//  Copyright © 2019 appi. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var color = ""
    var toDoItem = List<ToDoItem>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name :String) {
        self.init()
        self.name = name
    }
}
