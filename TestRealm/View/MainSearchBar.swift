//
//  MainSearchBar.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/13.
//  Copyright © 2019 appi. All rights reserved.
//

import UIKit

class MainSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
