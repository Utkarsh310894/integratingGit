//
//  ViewController.swift
//  ToDoList
//
//  Created by Utkarsh Sharma on 14/06/18.
//  Copyright © 2018 Utkarsh Sharma. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
 
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sampleArray = [Item]()
    var selCatagory : Catagory? {
        didSet{
            loadItems()
        }
    }
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selCatagory?.colour{
            title = selCatagory!.name
            updateNavBar(withHexCode: colourHex)
        }

        
    }
    override func viewWillDisappear(_ animated: Bool) {
       
               updateNavBar(withHexCode: "005493")
    }
    
    //MARK:- NAVIGATATION BAR APPEARANCE
    func updateNavBar (withHexCode  colourHexCode:String)
    {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navigation Controller doesnot exist")
        }
        if let navBarColour = UIColor(hexString: colourHexCode)
        {
            navBar.barTintColor = navBarColour
            navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:ContrastColorOf(navBarColour, returnFlat: true)]
            searchBar.barTintColor = navBarColour
        }
    }
    
    
    //TableView DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = super.tableView(tableView, cellForRowAt: indexPath )
       let item = sampleArray[indexPath.row]
        cell.backgroundColor = UIColor(hexString: (selCatagory?.colour)!)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(sampleArray.count))
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.textLabel?.text=item.itemName
        cell.accessoryType = item.status  ? .checkmark : .none
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        sampleArray[indexPath.row].status = !sampleArray[indexPath.row].status
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    //MARK :- ADD BUTTON CLIKED
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var TextFeild = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "Do you want to add new items?", preferredStyle:.alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .cancel) { (cancel) in
            
        }
        let addAction = UIAlertAction(title: "ADD", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.itemName = TextFeild.text!
            newItem.parentCatagory = self.selCatagory
            newItem.status = false
            
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
        do
        {
            
          try  context.save()
            
        }
        catch{
            print("Error saving data into sampleArray \(error)")
        }
         tableView.reloadData()
    }
    
    // MARK:- Load Data
    func loadItems(with request : NSFetchRequest<Item> =  Item.fetchRequest() , predicate : NSPredicate? = nil  )
    {
        let catagoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selCatagory!.name! )
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPredicate,predicate])
//        request.predicate = compoundPredicate
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPredicate,additionalPredicate])
        }
        else{
            request.predicate = catagoryPredicate
        }

        do{
            sampleArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        
    }
    
    //MARK:- Delete Data
    override func updateModel(at indexPath: IndexPath) {
       
        context.delete(sampleArray[indexPath.row])
        sampleArray.remove(at: indexPath.row)
        do{
        try context.save()
        }
        catch
        {
            print("Error During Deletion")
        }
    }
    
    
    

}


extension ToDoListViewController : UISearchBarDelegate {
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item>=Item.fetchRequest()
        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        loadItems(with: request,predicate: predicate)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}

