//
//  TaskTableDelegate.swift
//  Funflow
//
//  Created by Jayson Galante on 27/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import Foundation
import UIKit
import BEMCheckBox

class UITaskTableDelegate : NSObject, UITableViewDelegate, UITableViewDataSource, BEMCheckBoxDelegate, UITextViewDelegate, UITextInputTraits {
    
    var pageView : UIViewController!
    var addButton : UIButton!
    var tasks : [Task]!
    var isEditable : Bool = true
    var progressView : UICircularProgressBar?
    var tableView : UITaskTableView!
    
    var flowID : Int?
    
    let taskCell = "taskCell"
    
    init(pageView: UIViewController, tasks : [Task], tableView : UITaskTableView){
        self.tasks = tasks
        self.tableView = tableView
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
        
        cell.task = self.tasks[indexPath.row]
        if (self.progressView != nil){
            cell.progressView = self.progressView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isEditable
    }
    
    func addTask(){
        self.tableView.beginUpdates()
        
        let task = Task()
        if (flowID != nil) {
            task.flowID = self.flowID
            do{
                let dbController = try DBController()
                try dbController.taskDAO.insert(task: task)
                task.id = Int(dbController.taskDAO.lastRowID)
                
                if (self.progressView != nil){
                    let flow = try dbController.flowDAO.selectByID(self.flowID!)
                    self.progressView?.progress = flow.progress
                }
            }
            
            catch{
                print(error)
            }
        }
        
        self.tasks.append(task)
        let indexPath = IndexPath(row: self.tasks.count-1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if self.isEditable{
            
            if editingStyle == .delete{
                
                if (self.tasks[indexPath.row].hasID){
                    do{
                        let dbController = try DBController()
                        try dbController.taskDAO.delete(id: self.tasks[indexPath.row].id)
                        
                        if (self.flowID != nil && self.progressView != nil){
                            let flow = try dbController.flowDAO.selectByID(self.flowID!)
                            self.progressView?.progress = flow.progress
                        }
                    }
                    
                    catch{
                        print(error)
                    }
                }
                
                self.tasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
