//
//  ViewController.swift
//  ToDoList
//
//  Created by Utkarsh Sharma on 14/06/18.
//  Copyright © 2018 Utkarsh Sharma. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
 
    var sampleArray = ["soap","detergent","Shampoo","sanitizer"]
    //ADDING USER DEFAULTS
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "List") as? [String] {
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
        cell.textLabel?.text=sampleArray[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var TextFeild = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Do you want to add new items?", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel) { (cancel) in
            
        }
        let addAction = UIAlertAction(title: "ADD", style: .default) { (action) in
            self.sampleArray.append(TextFeild.text!)
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

