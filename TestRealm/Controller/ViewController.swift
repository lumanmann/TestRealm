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

class ViewController: UIViewController, DBManagerDelegate {
    
    
    let tableView = UITableView()
    var dbManager = DBManager.shared
    var todos: Results<ToDoItem>? {
        get {
            return dbManager.todos
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        dbManager.getFileURL()
        configureDB()
        configureNavItem()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func configureDB() {
        dbManager.delegate = self
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
        let vc = AddItemViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resetItems() {
        dbManager.deleteAll()
    }
    
    // MARK: DBManagerDelegate
    func didFinishEditing() {
        tableView.reloadData()
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    
        
        cell?.textLabel?.text = todos![indexPath.row].name
       // cell?.imageView?.image =  todos![indexPath.row].image as? UIImage
        if todos![indexPath.row].isDone {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DBManager.shared.setIsDone(item: todos![indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DBManager.shared.delete(item: todos![indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

