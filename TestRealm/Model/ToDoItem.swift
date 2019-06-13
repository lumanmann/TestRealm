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
    @objc dynamic var type: String = ""
    @objc dynamic var image: Data?
    
    convenience init(name: String) {
        self.init()
        self.name = name

    }
}
