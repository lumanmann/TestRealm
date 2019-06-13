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
    
    func loadImagefrom(path: String) -> UIImage? {
        guard let url = URL(string: path)  else {
            return nil
        }
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            return image
        }
        
        return nil
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    
        
        cell?.textLabel?.text = todos![indexPath.row].name
       
        if todos![indexPath.row].isDone {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        if let image = loadImagefrom(path: todos![indexPath.row].imagePath) {
            cell?.imageView?.image = image
        }
        
        if let owner = todos![indexPath.row].owner {
            let color = UIColor.init(hexString: owner.color)
            
            cell?.backgroundColor = color
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
    
}

extension UIColor {
    class func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.8)
    }
    
  
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
}
