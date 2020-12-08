//
//  AddViewController.swift
//  Todoex
//
//  Created by Admin on 10/6/20.
//

import UIKit

class AddVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    public var completion: ((String, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTapped))
    }
    
    @objc func saveTapped() {
        if let titleText = titleText.text, !titleText.isEmpty {
            let targetDate = datePicker.date
            completion?(titleText, targetDate)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    

}
