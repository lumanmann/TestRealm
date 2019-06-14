//
//  CustomToolBar.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/14.
//  Copyright © 2019 appi. All rights reserved.
//

import UIKit

class CustomToolBar: UIToolbar {
    
    var handler: (() -> Void)?
    
    convenience init(selector: Selector) {
        self.init(frame: .zero)
       
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: selector)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        setItems([ spaceItem, doneButton], animated: false)
        
    }
    
    convenience init() {
        self.init(frame: .zero)
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneClicked))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        setItems([ spaceItem, doneButton], animated: false)
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        barStyle = UIBarStyle.default
        isTranslucent = true
        sizeToFit()
        isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func doneClicked() {
        handler?()
    }
    
    
}
