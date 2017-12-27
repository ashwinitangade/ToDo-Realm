//
//  ViewController.swift
//  ToDo
//
//  Created by Ashwini Tangade on 12/27/17.
//  Copyright © 2017 Ashwini Tangade. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["First", "Second", "Third"]
    override func viewDidLoad() {
        super.viewDidLoad()

        //let swipeGester = UITapGestureRecognizer(target: self, action: )
    }

    //MARK: - TableView Datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }


    //MARK:  - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none

        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

