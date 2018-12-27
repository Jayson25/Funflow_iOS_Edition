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
    
    var tasks : [Task]!
    let taskCell = "taskCell"
    //var didSelectRow : ((_ dataItem: Int, _ cell: UITableViewCell) -> Void)?
    
    init(_ tasks : [Task]){
        self.tasks = tasks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskCell) as! TaskCell
        return cell
    }
}
