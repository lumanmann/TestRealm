//
//  ViewController.swift
//  TestRealm
//
//  Created by Natalie Ng on 2019/6/11.
//  Copyright © 2019 appi. All rights reserved.
//

import UIKit
import RealmSwift
import SnapKit

class ViewController: UIViewController {
    let tableView = UITableView()
    let type1 = ToDoType(name: "WORK")
    let type2 = ToDoType(name: "LEISURE")
    lazy var realm = try! Realm()
    
    var todos: Results<ToDoItem> {
        get {
            return realm.objects(ToDoItem.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL!)
        configureDB()
        configureNavItem()
        configureTableView()
    }
    
    private func configureDB() {
        try! realm.write {
            realm.add(type1)
            realm.add(type2)
        }
        
    }
    
    private func configureNavItem() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let resetBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetItems))
        self.navigationItem.setRightBarButtonItems([resetBtn, addBtn], animated: true)
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }

    }
    
    @objc func addItem() {
        
        let item = ToDoItem(name: "Test", type: type1)

        try! realm.write {
            realm.add(item)
        }
        tableView.reloadData()
        
        //        let vc = AddItemViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resetItems() {

        try? realm.write {
            realm.deleteAll()
        }
         tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    
        
        cell?.textLabel?.text = todos[indexPath.row].name
        cell?.imageView?.image = UIImage()
        cell?.accessoryType = .checkmark
        
        return cell!
    }
    
    
}

