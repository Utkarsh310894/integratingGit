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
    
     let dataFilePath = FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print(dataFilePath)
        
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
        
        loadItems()
        

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
        saveItem()
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
            self.saveItem()
        }
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Add Item"
            TextFeild = alertTextFeild
            
        }
        
      
        alert.addAction(addAction)
        alert.addAction(cancel)
        
        present(alert,animated: true,completion: nil)
    }
    
    
    func saveItem ()
    {
        let encoder =  PropertyListEncoder()
        do
        {
            
            let data = try encoder.encode(sampleArray)
            try data.write(to:dataFilePath!)
            
        }
        catch{
            print("Error encoding sampleArray \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems()
    {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                sampleArray = try decoder.decode([Item].self, from: data)
            }
            catch{
                print("Error decoding Sample Array\(error)")
            }
        }
    }
    
    
    

}

