//
//  DocumentsTableViewController.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit
import CoreData

class DocumentsTableViewController: UITableViewController {
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNewDocument", sender: nil)
    }
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    var documents = [Document]()
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Document> = Document.fetchRequest()
        
        do {
            documents = try managedContext.fetch(fetchRequest)
            
            tableView.reloadData()
        } catch {
            print("Could not fetch documents")
        }
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedContext = document.managedObjectContext {
            managedContext.delete(document)
            
            do {
                try managedContext.save()
                
                self.documents.remove(at: indexPath.row)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } catch{
                print("Could not delete document")
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        let document = documents[indexPath.row]
        
        if let cell = cell as? DocumentTableViewCell {
            cell.titleLabel.text = document.title
            
            if let dateModified = document.dateModified {
                cell.modifiedLabel.text = dateFormatter.string(from: dateModified)
            }
            
            if let size = document.size {
                cell.sizeLabel.text = String(size) + " bytes"
            }
            else {
                cell.sizeLabel.text = ""
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentViewController {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                destination.existingDocument = self.documents[selectedRow]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToNewDocument", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            deleteDocument(at: indexPath)
        }
    }
}
