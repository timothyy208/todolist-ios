//
//  DetailViewController.swift
//  To Do List
//
//  Created by Timothy Yang on 2/11/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var toDoItem: String?
    var toDoNote: String?
    @IBOutlet weak var toDoField: UITextField!
    
    @IBOutlet weak var noteField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let toDoItem = toDoItem{
            toDoField.text = toDoItem
            self.navigationItem.title = "Edit To Do Item"
        } else {
            self.navigationItem.title = "New To Do Item"
        }
        
        if let toDoNote = toDoNote {
            noteField.text = toDoNote
        }
       
        enableDisableSaveButton()
        toDoField.becomeFirstResponder()
        
        
    }
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBAction func toDoFieldChanged(_ sender: UITextField) {
        enableDisableSaveButton()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    `    func enableDisableSaveButton() {
        if toDoField.text!.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromSave" {
            toDoItem = toDoField.text
            toDoNote = noteField.text
        }
    }
    


}
