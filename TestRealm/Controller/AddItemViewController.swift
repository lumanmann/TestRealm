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
        tf.placeholder = "Please enter a to-do"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let deadlineTf: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Please enter a deadline"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let ownerBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Choose owner", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .lightGray
        btn.addTarget(self, action: #selector(pickOwner), for: .touchUpInside)
        return btn
    }()
    
    let type1Btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("WORK", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.blue, for: .selected)
        btn.backgroundColor = .lightGray
        btn.tag = 111
        return btn
    }()
    
    let type2Btn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("LEISURE", for: .normal)
        btn.setTitleColor(.blue, for: .selected)
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
        btn.layer.borderWidth = 1.0
        btn.addTarget(self, action: #selector(selectPicture), for: .touchUpInside)
        return btn
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale.current
        datePicker.date = NSDate() as Date
        return datePicker
    }()
    
    let dbManager = DBManager.shared
    var picture: UIImage?
    var item = ToDoItem()
    var owner: Person?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        
    }
    
    // MARK: Setup views
    private func setupViews() {
        eventTf.delegate = self
        deadlineTf.inputView = datePicker
        deadlineTf.inputAccessoryView = UIToolbar().getCustomToolbarPicker(selector: #selector(dismissDatePicker))
        type1Btn.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        type2Btn.addTarget(self, action: #selector(itemClick), for: .touchUpInside)
        
        view.addSubview(ownerBtn)
        view.addSubview(eventTf)
        view.addSubview(imageBtn)
        view.addSubview(deadlineTf)
        
        configureNavItem()
        layoutView()
        
    }
    
    private func layoutView() {
        let stackView = UIStackView(arrangedSubviews: [type1Btn, type2Btn])
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        imageBtn.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.2)
            make.width.equalToSuperview().multipliedBy(0.7)
            make.top.equalTo(view.snp.topMargin).offset(60)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.05)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(imageBtn.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
        }
        
        
        eventTf.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(type1Btn.snp.bottom).offset(20)
            make.height.equalTo(stackView.snp.height)
        }
        
        ownerBtn.snp.makeConstraints { (make) in
            make.size.equalTo(eventTf.snp.size)
            make.top.equalTo(eventTf.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        deadlineTf.snp.makeConstraints { (make) in
            make.size.equalTo(eventTf.snp.size)
            make.top.equalTo(ownerBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        
        
    }
    
    private func configureNavItem() {
        let saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveItem))
        
        self.navigationItem.setRightBarButton(saveBtn, animated: true)
    }
    
    // MARK: Other
    @objc func selectPicture(_ sender: UIButton) {
        let alert =  UIAlertController(title: nil , message: "請選擇一張照片上傳", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "拍攝照片", style: .default) { (action) in
            self.pickAnImage(from: .camera)
        }
        
        let libraryAction = UIAlertAction(title: "選擇照片", style: .default) { (action) in
            self.pickAnImage(from: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func pickAnImage(from source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func itemClick(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 111 {
            type2Btn.isSelected = false
        } else {
            type1Btn.isSelected = false
        }
        item.type = sender.currentTitle ?? ""
    }
    
    @objc func saveItem() {
        guard let name = eventTf.text, name.count > 0, item.type != "", owner !=  nil else { return }
        item.name = name
        dbManager.add(item: item, owner: owner!)

        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func pickOwner() {
        
        let alert = UIAlertController(title: "Choose an owner", message: "", preferredStyle: .actionSheet);
        
        for owner in DBManager.shared.pepeole {
            let action = UIAlertAction(title: "\(owner.name)", style: .default, handler: {[unowned self](_) -> Void in
                self.owner = owner
                self.ownerBtn.setTitle(owner.name, for: .normal)
            })
            
            alert.addAction(action)
        }
        
        let add = UIAlertAction(title: "Add Owner", style: .destructive, handler: {[unowned self](_) -> Void in
            self.addNewOwner()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        self.present(alert, animated: false, completion: nil)
        
    }
    
    
    @objc func dismissDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePicker.date)
        deadlineTf.text = date
        item.deadline = datePicker.date
        view.endEditing(true)
    }
    
    func addNewOwner() {
        let alert = UIAlertController(title: "Add Owner", message: "", preferredStyle: .alert)
        var tf: UITextField?
        alert.addTextField(configurationHandler: {
            (textField:UITextField!) -> Void in
            textField.placeholder = "Enter owner name"
            tf = textField
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(cancel)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            guard let name = tf?.text else { return }
            let person = Person(name: name)
            
            let color = UIColor.generateRandomColor().toHexString()
            
            person.color = color
            
            DBManager.shared.add(owner: person)
            
            tf?.resignFirstResponder()
            
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageURL = info[.imageURL] as? URL
        item.imagePath = imageURL?.absoluteString ?? ""
        
        self.picture = info[.originalImage] as? UIImage
        self.imageBtn.setImage(picture, for: .normal)
        self.imageBtn.imageView?.contentMode = .scaleAspectFill
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension UIToolbar {
    
    func getCustomToolbarPicker(selector: Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: selector)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceItem, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    
    
}
