//
//  ViewController.swift
//  Notes
//
//  Created by macbook on 7/7/22.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    var paragraph = [Paragraph]()
    
    var selectedNote: Notes?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var text: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadText()
        if paragraph.count > 0 {
            text.text = paragraph[0].text
        }
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        
        text.delegate = self
        text.resignFirstResponder()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        let newText = Paragraph(context: self.context)
        newText.text = textField.text!
        newText.parentNote = self.selectedNote
        
        if(paragraph.count > 0) {
            paragraph[0] = newText
        } else {
            paragraph.append(newText)
        }

        self.saveText()

    }
    
    func saveText() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadText(with request: NSFetchRequest<Paragraph> = Paragraph.fetchRequest()) {
        
        
        let predicate = NSPredicate(format: "parentNote.title MATCHES %@", selectedNote!.title!)
        
        request.predicate = predicate
        
        do {
            paragraph = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
    
}
