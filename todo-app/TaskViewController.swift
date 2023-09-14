//
//  TaskViewController.swift
//  Todo-app
//
//  Created by Artem Bodryi on 13/09/2023.
//

import UIKit

protocol TaskViewControllerDelegate: AnyObject {
    func didDeleteTask(at index: Int)
}

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var task: (String, Int)!
    var taskIndex: Int?
    weak var delegate: TaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = task.0
           navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
           
           // Saving task's index for using it after delete
           self.taskIndex = task.1
        
    }
    
    @objc func deleteTask() {
        
        if let index = taskIndex {
                // Delete task from UserDefaults
                UserDefaults().setValue(nil, forKey: "task_\(index + 1)")
                
                // Updating tasks amount
                if var count = UserDefaults().value(forKey: "count") as? Int {
                    count -= 1
                    UserDefaults().setValue(count, forKey: "count")
                }
                
                // Telling to delegate about deleting the task
                delegate?.didDeleteTask(at: index)
            
                // Go back to previous screen
                navigationController?.popViewController(animated: true)
            }
    }
    

}
