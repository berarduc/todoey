//
//  CategoryViewController.swift
//  todoey
//
//  Created by tomberarducci on 3/1/19.
//  Copyright © 2019 tomberarducci. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    


    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
        
    }
    //Mark: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    
    //Mark: - Data Manipulation Methods
    
    func saveCategories(){
        
        print("saveCategories entered...")
        
        do{
            try context.save()
            print("context saved successfully.")
        }
        catch{
            print("\n\nERROR saving category context...error = \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        print("\n\nLoad Categories called...")
        do{
            try categoryArray = context.fetch(request)
        }
        catch{
            print("\n\nERROR loading category context...error: \(error)")
        }
        tableView.reloadData()
    }

    //Mark: - Add New Categories

@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    print("\n\nAdd button pressed...\n")
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "Enter new category name then hit 'Add'\nTo cancel, hit 'Cancel'", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add", style: .default) { (action) in
        let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        self.categoryArray.append(newCategory)
        self.saveCategories()
        }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
        alert.dismiss(animated: true, completion: nil)
    })
        
    alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "enter new category name here"
        textField = alertTextField
    }
    
    alert.addAction(cancelAction)
    alert.addAction(action)

    present(alert, animated: true, completion: nil)
    
    
}
    
    
    
    
}
