//
//  CatagoryViewController.swift
//  ToDoList
//
//  Created by Utkarsh Sharma on 15/06/18.
//  Copyright © 2018 Utkarsh Sharma. All rights reserved.
//

import UIKit
import CoreData 

class CatagoryViewController: UITableViewController {
    var catagoryArray = [Catagory]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCatagories()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catagoryArray.count
        
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "catagoryCell", for: indexPath)
        let catagory = catagoryArray[indexPath.row]
        cell.textLabel?.text = catagory.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "catagoryItem", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? ToDoListViewController
        if let index = tableView.indexPathForSelectedRow
        {
            destination?.selCatagory = catagoryArray[index.row]
        }
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFeild = UITextField()
        let alert = UIAlertController(title: "Add Catagory", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel) { (cancel) in
            
        }
        let addCatagory = UIAlertAction(title: "ADD", style: .default) { (action) in
            var newCatagory = Catagory(context: self.context)
            newCatagory.name = textFeild.text!
            self.catagoryArray.append(newCatagory)
            self.saveCatagory()
            
        }
        alert.addTextField { (alertTextfeild) in
            alertTextfeild.placeholder = "Add new catagory"
            textFeild = alertTextfeild
        }
        alert.addAction(cancel)
        alert.addAction(addCatagory)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCatagory() {
        do{
        try context.save()
        }
        catch{
            print("Error saving sampleArray \(error)")
        }
        tableView.reloadData()
    }
    func loadCatagories(with request : NSFetchRequest<Catagory> = Catagory.fetchRequest())
    {
        do{
        catagoryArray = try context.fetch(request)
        }
        catch{
            print("error during fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}
