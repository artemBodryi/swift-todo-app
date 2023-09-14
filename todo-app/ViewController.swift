//
//  ViewController.swift
//  Todo-app
//
//  Created by Artem Bodryi on 13/09/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }

        
        // Get all current saved tasks
        updateTasks()
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                tasks.append(task)
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async{
                self.updateTasks()
            }
        }
            
            navigationController?.pushViewController(vc , animated: true)
    }
}

extension ViewController: TaskViewControllerDelegate {
    func didDeleteTask(at index: Int) {
        // Delete task from tasks array
        tasks.remove(at: index)
        
        // Refresh table
        tableView.reloadData()
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        let taskIndex = indexPath.row
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "New Task"
        
        vc.task = (task, taskIndex)
        vc.delegate = self
        
        navigationController?.pushViewController(vc , animated: true)
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
    }
}

