//
//  AddItemViewController.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/12.
//  Copyright © 2019 appi. All rights reserved.
//

import UIKit
import SnapKit

class AddItemViewController: UIViewController {
    
    let eventTf: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavItem()
    }
    
    private func configureNavItem() {
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
    }
    
    
    @objc func saveItem() {
        
        
        self.navigationController?.popViewController(animated: true)
    }
}
