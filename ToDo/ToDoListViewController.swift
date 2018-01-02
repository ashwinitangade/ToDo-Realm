//
//  ViewController.swift
//  ToDo
//
//  Created by Ashwini Tangade on 12/27/17.
//  Copyright © 2017 Ashwini Tangade. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var toDoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
       
    }

    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        updateNavBar(withHexCode: selectedCategory!.bgColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "C68AC0")
    }
    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.bgColor)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(toDoItems!.count))){
                cell.backgroundColor = color
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
        }else{
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    //MARK:  - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: -  Navigation bar update Methods
    func updateNavBar(withHexCode colorHexCode : String)
    {
        guard let navBar = navigationController?.navigationBar else {fatalError("NavigationBar does not exist")}
        guard let colorHex = UIColor(hexString: colorHexCode) else {fatalError()}
        
        navBar.barTintColor = colorHex
        navBar.largeTitleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue) : UIColor(contrastingBlackOrWhiteColorOn: colorHex, isFlat: true)]
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: colorHex, isFlat: true)
        searchBar.barTintColor = colorHex
    }

    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           

            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    
                    let nserror = error as NSError
                    fatalError("Error saving new item \(nserror), \(nserror.userInfo)")
                }
            }
           
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //////////////////////////////
    //MARK: - Save Items
    
    func saveItems(item : Item){
        
        
    }
    
    
    ///////////////////////////////
    //MARK: - Load Items from coredata
    
    func loadItems()  {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    ////delete items
    override func updateDataModel(at indexPath: IndexPath) {
        do {
            try realm.write {
                if let item = toDoItems?[indexPath.row]{
                    realm.delete(item)
                }
            }
        }catch{
            print("Error Deleting Item \(error)")
        }
    }

}

//MARK: - Search bar methods
extension ToDoListViewController : UISearchBarDelegate{
    ///////////////////////////////////
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

