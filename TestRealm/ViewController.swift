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

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        print(realm.configuration.fileURL!)
        configureNavItem()
        configureTableView()
    }
    
    private func configureNavItem() {
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        let rightBtn1 = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        self.navigationItem.setRightBarButtonItems([rightBtn1, rightBtn], animated: true)
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


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

