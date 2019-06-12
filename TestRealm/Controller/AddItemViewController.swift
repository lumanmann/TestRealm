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
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let type1Btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Type 1", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .lightGray
        btn.tag = 111
        return btn
    }()
    
    let type2Btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Type 2", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .lightGray
        btn.tag = 222
        return btn
    }()
    
    let imageBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    
    let dbManager = DBManager.shared
    let type1 = ToDoType(name: "WORK")
    let type2 = ToDoType(name: "LEISURE")
    var item = ToDoItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
    }
    
    private func setupViews() {
        eventTf.delegate = self
        type1Btn.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        type2Btn.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        
        view.addSubview(eventTf)
        
        configureNavItem()
        layoutView()
        
    }
    
    private func layoutView() {
        let stackView = UIStackView(arrangedSubviews: [type1Btn, type2Btn])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(view.snp.topMargin).offset(60)
            make.centerX.equalToSuperview()
        }
        

        eventTf.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(type1Btn.snp.bottom).offset(20)
            make.height.equalTo(stackView.snp.height)
        }
        
    
        
    }
    
    private func configureNavItem() {
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
    }
    
    @objc func itemClick(_ sender: UIButton) {
        switch sender.tag {
        case 111:
            item.type = type1
        case 222:
            item.type = type2
        default: return
        }
    }
    
    @objc func saveItem() {
        guard let name = eventTf.text else { return }
        item.name = name
        
        if item.name.count > 0 && item.type != nil {
            dbManager.add(item: item)
            self.navigationController?.popViewController(animated: true)
        }
    
        
    }
}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}
