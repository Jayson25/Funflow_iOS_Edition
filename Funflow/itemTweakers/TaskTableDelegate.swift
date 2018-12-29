//
//  TaskTableDelegate.swift
//  Funflow
//
//  Created by Jayson Galante on 27/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import Foundation
import UIKit

class TaskTableDelegate : NSObject, UITableViewDelegate, UITableViewDataSource{
    
    var pageView : UIViewController!
    var addButton : UIButton!
    
    var tasks : [Task]!
    
    var num = 10
    var isEditable : Bool = true
    
    let taskCell = "taskCell"
    //var didSelectRow : ((_ dataItem: Int, _ cell: UITableViewCell) -> Void)?
    
    init(_ pageView: UIViewController, _ tasks : [Task]){
        self.tasks = tasks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tasks.count == 0){
                tableView.separatorStyle = .none
                tableView.backgroundView?.isHidden = false
        }
        
        else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }
        
        return tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCell) as! TaskCell
        cell.task = tasks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if self.isEditable{
            
            if editingStyle == .delete{
                print(tableView.numberOfRows(inSection: indexPath.section))
                
                tableView.beginUpdates()
                tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
    }
}
