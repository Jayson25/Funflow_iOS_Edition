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
    
    let id = Expression<Int>("ID")
    let flowID = Expression<Int>("flowID")
    let description = Expression<String>("description")
    let isDone = Expression<Bool>("isDone")
    
    var lastRowID : Int64!
    
    init(_ dbConnector: Connection, flowDAO: FlowDAO) throws {
        self.dbConnector = dbConnector
        self.flowDAO = flowDAO
        
        try dbConnector.run(self.taskTable.create(ifNotExists: true){ t in
            t.column(self.id, primaryKey: .autoincrement)
            t.column(self.flowID)
            t.column(self.description)
            t.column(self.isDone, defaultValue: false)
            t.foreignKey(self.flowID, references: flowDAO.flowTable, flowDAO.id, delete: .cascade)
        })
    }
    
    func insert(task: Task) throws {
        try dbConnector.run(self.taskTable.insert(
            self.flowID <- task.flowID,
            self.description <- task.description,
            self.isDone <- task.isDone
        ))
        
        self.lastRowID = dbConnector.lastInsertRowid
    }
    
    func delete(id : Int) throws {
        let task = self.taskTable.filter(self.id == id)
        try dbConnector.run(task.delete())
    }
    
    func delete(flowID : Int) throws {
        let tasks = self.taskTable.filter(self.flowID == flowID)
        try dbConnector.run(tasks.delete())
    }
    
    func select(flowID: Int) throws -> [Task]{
        let tasks = self.taskTable.filter(self.flowID == flowID)
        var listOfTasks = [Task]()
        
        for taskProperties in try dbConnector.prepare(tasks){
            let task = Task(taskProperties[self.id],
                            flowID: taskProperties[self.flowID],
                            description: taskProperties[self.description],
                            isDone: taskProperties[self.isDone])
            
            listOfTasks.append(task)
        }
        
        return listOfTasks
    }
    
    func select(id: Int) throws -> Task{
        let task = self.taskTable.filter(self.id == id)
        
        for taskProperties in try dbConnector.prepare(task){
            return Task(taskProperties[self.id],
                        flowID: taskProperties[self.flowID],
                        description: taskProperties[self.description],
                        isDone: taskProperties[self.isDone])
        }
        
        return Task()
    }
    
    func update(_ id : Int, description desc : String, isDone : Bool) throws {
        let task = self.taskTable.filter(self.id == id)
        
        try dbConnector.run(task.update(self.description <- desc))
        try dbConnector.run(task.update(self.isDone <- isDone))
    }
}
