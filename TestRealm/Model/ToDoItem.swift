//
//  ToDoItem.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/11.
//  Copyright © 2019 appi. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem: Object {
    @objc dynamic var name = ""
    @objc dynamic var isDone = false
    @objc dynamic var type: ToDoType?
    @objc dynamic var image: ToDoImage?
    
    convenience init(name: String, type: ToDoType) {
        self.init()
        self.name = name
        self.type = type
    }
}
