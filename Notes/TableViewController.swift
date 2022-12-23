//
//  ViewController.swift
//  Notes
//
//  Created by macbook on 7/7/22.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var notesArray = [Notes]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotes()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Note", message: "", preferredStyle: .alert)
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newNote = Notes(context: self.context)
            
            newNote.title = textField.text!
            
            self.notesArray.append(newNote)
            
            self.saveNotes()
            
        }
        
        alert.addAction(cancelAlert)
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            
            textField.placeholder = "Add new note"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notesArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        cell.textLabel?.text = notesArray[indexPath.row].title
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToText", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.selectedNote = notesArray[indexPath.row]
        }
    }
    
    func saveNotes() {
        
        do {
            try context.save()
        } catch {
            print("Error saving note \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadNotes() {
        
        let request: NSFetchRequest<Notes> = Notes.fetchRequest()
        
        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
        
    }
}

