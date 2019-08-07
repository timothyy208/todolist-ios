//
//  ViewController.swift
//  To Do List
//
//  Created by Timothy Yang on 2/11/19.
//  Copyright © 2019 Timothy Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var defaultsData = UserDefaults.standard
    
    var toDoArray = [String]()
    var notesArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        toDoArray = defaultsData.stringArray(forKey: "toDoArray") ?? [String]()
        notesArray = defaultsData.stringArray(forKey: "notesArray") ?? [String]()
        
    }
    
    func saveDefaultsData() {
        defaultsData.set(toDoArray, forKey: "toDoArray")
        defaultsData.set(notesArray, forKey: "notesArray")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let destination = segue.destination as! DetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            destination.toDoItem = toDoArray[index]
            destination.toDoNote = notesArray[index]
        } else {
            if let selectedPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedPath, animated: false)
            }
        }
    }
    
    @IBAction func unwindFromDetailViewController(segue: UIStoryboardSegue) {
        let sourceViewcontroller = segue.source as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            toDoArray[indexPath.row] = sourceViewcontroller.toDoItem!
            notesArray[indexPath.row] = sourceViewcontroller.toDoNote!
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            toDoArray.append(sourceViewcontroller.toDoItem!)
            notesArray.append(sourceViewcontroller.toDoNote!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveDefaultsData()
    }

    @IBAction func editBarButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        cell.detailTextLabel?.text = notesArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDoArray.remove(at: indexPath.row)
            notesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveDefaultsData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoArray[sourceIndexPath.row]
        let noteToMove = notesArray[sourceIndexPath.row]
        toDoArray.remove(at: sourceIndexPath.row)
        toDoArray.insert(itemToMove, at: destinationIndexPath.row)
        notesArray.remove(at: sourceIndexPath.row)
        notesArray.insert(noteToMove, at: destinationIndexPath.row)
        saveDefaultsData()
    }
    
}
