//
//  TaskDAO.swift
//  Funflow
//
//  Created by Jayson Galante on 02/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit
import SQLite

class TaskDAO{
    
    private let dbConnector : Connection!
    private let flowDAO : FlowDAO!
    let taskTable = Table("Task")
    
    let flowID = Expression<Int>("flowID")
    let description = Expression<String>("description")
    let isDone = Expression<Bool>("isDone")
    
    var lastRowID : Int64!
    
    init(_ dbConnector: Connection, flowDAO: FlowDAO) throws {
        self.dbConnector = dbConnector
        self.flowDAO = flowDAO
        
        try dbConnector.run(taskTable.create(ifNotExists: true){ t in
            t.column(self.flowID)
            t.column(self.description)
            t.column(self.isDone, defaultValue: false)
            t.foreignKey(self.flowID, references: flowDAO.flowTable, flowDAO.id, delete: .cascade)
        })
    }
    
    func insert(task: Task) throws {
        try dbConnector.run(taskTable.insert(
            self.flowID <- task.flowID,
            self.description <- task.description,
            self.isDone <- task.isDone
        ))
        
        self.lastRowID = dbConnector.lastInsertRowid
    }
    
    func delete(flowID : Int) throws {
        let tasks = taskTable.filter(self.flowID == flowID)
        try dbConnector.run(tasks.delete())
    }
    
    func select(flowID: Int) throws -> [Task]{
        let tasks = taskTable.filter(self.flowID == flowID)
        var listOfTasks = [Task]()
        
        for taskProperties in try dbConnector.prepare(tasks){
            let task = Task(flowID: taskProperties[self.flowID],
                            description: taskProperties[self.description],
                            isDone: taskProperties[self.isDone])
            
            listOfTasks.append(task)
        }
        
        return listOfTasks
    }
}
