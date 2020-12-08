//
//  ViewController.swift
//  Todoex
//
//  Created by Admin on 10/6/20.
//

import UIKit
import UserNotifications
import RealmSwift
import SwipeCellKit

class RemindersVC: UITableViewController, SwipeTableViewCellDelegate {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    let notifications = Notifications()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifications.testNotifiaction()
        
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        tableView.rowHeight = 100
        
        loadCategories()
        
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddVC else {
            return
        }
        vc.title = "New Reminder"
        vc.completion = { title, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = Category()
                new.name = title
                new.date = date
                self.save(category: new)
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "some_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if error != nil {
                        print("Something went wrong")
                    }
                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - Table View Delegates and Data Sources

extension RemindersVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            cell.textLabel!.font = UIFont(name: "Avenir", size: 25.0)
            
            let date = category.date
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM/dd/YYYY HH:mm a"
            cell.detailTextLabel?.text = formatter.string(from: date ?? Date())
            cell.detailTextLabel?.font = UIFont(name: "Avenir", size: 18.0)
            
            cell.accessoryType = category.done ? .checkmark : .none
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let category = categories?[indexPath.row] {
            do {
                try realm.write {
                    category.done = !category.done
                }
            } catch {
                print("Error saving data, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}


//MARK: - Swipe Cell Delegates

extension RemindersVC {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
       
        return options
    }
    
}

//MARK: - Realm Methods

extension RemindersVC {
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting data, \(error)")
            }
        }
        
    }
    
}
