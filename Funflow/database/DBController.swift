//
//  DBController.swift
//  Funflow
//
//  Created by Jayson Galante on 04/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit
import SQLite

class DBController {
    
    var dbConnector : Connection!
    var flowDAO : FlowDAO!
    var taskDAO : TaskDAO!
    var userDAO : UserDAO!
    
    let DB_VERSION = "1.0.0"
    
    init() throws {
        let documentFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentFolder.appendingPathComponent("Funflow-\(DB_VERSION)").appendingPathExtension("sqlite3")
        
        self.dbConnector = try Connection(fileURL.path)
        self.flowDAO = try FlowDAO(self.dbConnector)
        self.taskDAO = try TaskDAO(self.dbConnector, flowDAO: self.flowDAO)
        self.userDAO = try UserDAO(self.dbConnector)
    }
    
    func addFlow(flow: Flow, tasks: [Task]) throws{
        try self.flowDAO.insert(flow: flow)
        
        for _task in tasks{
            let task = Task(flowID: Int(truncatingIfNeeded: self.flowDAO.lastRowID), description: _task.description, isDone: _task.isDone)
            try self.taskDAO.insert(task: task)
        }
    }
}
