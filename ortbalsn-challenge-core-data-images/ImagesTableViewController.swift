//
//  DocumentsTableViewController.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit
import CoreData

class ImagesTableViewController: UITableViewController {
    
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToNewImage", sender: nil)
    }
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    
    var images = [Image]()
    
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
        let fetchRequest: NSFetchRequest<Image> = Image.fetchRequest()
        
        do {
            images = try managedContext.fetch(fetchRequest)
            
            tableView.reloadData()
        } catch {
            print("Could not fetch images")
        }
    }
    
    func deleteImage(at indexPath: IndexPath) {
        let image = images[indexPath.row]
        
        if let managedContext = image.managedObjectContext {
            managedContext.delete(image)
            
            do {
                try managedContext.save()
                self.images.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            } catch{
                print("Could not delete image")
                
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        let image = images[indexPath.row]
        
        if let cell = cell as? ImageTableViewCell {
            cell.titleLabel.text = image.title
            
            if let dateModified = image.dateModified {
                cell.modifiedLabel.text = dateFormatter.string(from: dateModified)
            }
            
            if let size = image.size {
                cell.sizeLabel.text = String(size) + " bytes"
            }
            else {
                cell.sizeLabel.text = ""
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ImageViewController {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                destination.existingImage = self.images[selectedRow]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "moveToNewImage", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            deleteImage(at: indexPath)
        }
    }
}
