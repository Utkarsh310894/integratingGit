//
//  ViewController.swift
//  ToDoList
//
//  Created by Utkarsh Sharma on 14/06/18.
//  Copyright © 2018 Utkarsh Sharma. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
 
    var sampleArray = [Item]()
    //ADDING USER DEFAULTS
  var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.itemName = "Soap"
        sampleArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.itemName = "Detergent"
        sampleArray.append(newItem2)
        
        let newItem4 = Item()
        newItem4.itemName = "Papersoap"
        sampleArray.append(newItem4)
        
        let newItem5 = Item()
        newItem5.itemName = "Shampoo"
        sampleArray.append(newItem5)
        
        if let items = defaults.array(forKey: "List") as? [Item]
          { 
            sampleArray=items
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    //TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CopyMAtKar", for: indexPath)
        let item = sampleArray[indexPath.row]
        cell.textLabel?.text=item.itemName
        cell.accessoryType = item.status  ? .checkmark : .none

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sampleArray[indexPath.row].status = !sampleArray[indexPath.row].status
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var TextFeild = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Do you want to add new items?", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel) { (cancel) in
            
        }
        let addAction = UIAlertAction(title: "ADD", style: .default) { (action) in
            var newItem = Item()
            newItem.itemName = TextFeild.text!
            self.sampleArray.append(newItem)
            self.defaults.set(self.sampleArray, forKey: "List")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Add Item"
            TextFeild = alertTextFeild
            
        }
        
      
        alert.addAction(addAction)
        alert.addAction(cancel)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    

}

