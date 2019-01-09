//
//  FlowDAO.swift
//  Funflow
//
//  Created by Jayson Galante on 02/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit
import SQLite

class FlowDAO{
    
    private let dbConnector : Connection!
    let flowTable = Table("Flow")
    
    let id = Expression<Int>("id")
    let title = Expression<String>("title")
    let image = Expression<String>("image")
    let category = Expression<String>("category")
    let author = Expression<String>("author")
    let releaseDate = Expression<String>("releaseDate")
    let rating = Expression<Int>("rating")
    let description = Expression<String>("description")
    
    var lastRowID : Int64!
    
    enum FieldSQLiteError : Error{
        case titleIsEmpty
        case notAnInteger
        case isEmpty
    }
    
    init(_ dbConnector: Connection) throws {
        
        self.dbConnector = dbConnector

        try dbConnector.run(flowTable.create(ifNotExists: true){ t in
            t.column(self.id, primaryKey: .autoincrement)
            t.column(self.title, unique: true)
            t.column(self.image)
            t.column(self.category, defaultValue: "Others")
            t.column(self.author, defaultValue: "N/A")
            t.column(self.releaseDate)
            t.column(self.rating, defaultValue: 1)
            t.column(self.description)
        })
    }
    
    func insert(flow : Flow) throws {
        if (flow.title == ""){
            throw FieldSQLiteError.titleIsEmpty
        }
        
        try dbConnector.run(flowTable.insert(
            self.title <- flow.title,
            self.image <- flow.image,
            self.category <- flow.category,
            self.author <- flow.author,
            self.releaseDate <- flow.releaseDate,
            self.rating <- flow.rating,
            self.description <- flow.description
        ))
        
        self.lastRowID = dbConnector.lastInsertRowid
    }
    
    func selectAll() throws -> [Flow] {
        var listOfFlows = [Flow]()
        
        for flowProperties in try dbConnector.prepare(flowTable){
            let flow = Flow(flowProperties[self.id],
                            title: flowProperties[self.title],
                            image: flowProperties[self.image],
                            category: flowProperties[self.category],
                            author: flowProperties[self.author],
                            releaseDate: flowProperties[self.releaseDate],
                            rating: flowProperties[self.rating],
                            description: flowProperties[self.description])
            
            listOfFlows.append(flow)
        }
        
        return listOfFlows
    }
    
    func selectByCategory(_ category: String) throws -> [Flow] {
        
        let flows = flowTable.filter(self.category == category)
        var listOfFlows = [Flow]()
        
        for flowProperties in try dbConnector.prepare(flowTable){
            let flow = Flow(flowProperties[self.id],
                            title: flowProperties[self.title],
                            image: flowProperties[self.image],
                            category: flowProperties[self.category],
                            author: flowProperties[self.author],
                            releaseDate: flowProperties[self.releaseDate],
                            rating: flowProperties[self.rating],
                            description: flowProperties[self.description])
            
            listOfFlows.append(flow)
        }
        
        return listOfFlows
    }
    
    func selectByTitle(_ title: String) throws -> Flow {
        let flows = flowTable.filter(self.category == category)
        var flow : Flow!
        
        for flowProperties in try dbConnector.prepare(flows){
            flow = Flow(flowProperties[self.id],
                            title: flowProperties[self.title],
                            image: flowProperties[self.image],
                            category: flowProperties[self.category],
                            author: flowProperties[self.author],
                            releaseDate: flowProperties[self.releaseDate],
                            rating: flowProperties[self.rating],
                            description: flowProperties[self.description])
            
            return flow
        }
        
        return flow
    }
    
    func selectByID(_ id: Int) throws -> Flow {
        let flows = flowTable.filter(self.id == id)
        var flow : Flow!
        
        for flowProperties in try dbConnector.prepare(flows){
            flow = Flow(flowProperties[self.id],
                        title: flowProperties[self.title],
                        image: flowProperties[self.image],
                        category: flowProperties[self.category],
                        author: flowProperties[self.author],
                        releaseDate: flowProperties[self.releaseDate],
                        rating: flowProperties[self.rating],
                        description: flowProperties[self.description])
            
            return flow
        }
        
        return flow
    }
    
    func delete(id : Int) throws {
        let flow = flowTable.filter(self.id == id)
        try dbConnector.run(flow.delete())
    }
    
    func deleteAll() throws {
        try dbConnector.run(flowTable.delete())
    }
    
    func update(_ id : Int, flow: Flow) throws {
        let flowQuery = flowTable.filter(self.id == id)
        
        try dbConnector.run(flowQuery.update(self.title <- flow.title))
        try dbConnector.run(flowQuery.update(self.image <- flow.image))
        try dbConnector.run(flowQuery.update(self.category <- flow.category))
        try dbConnector.run(flowQuery.update(self.author <- flow.author))
        try dbConnector.run(flowQuery.update(self.releaseDate <- flow.releaseDate))
        try dbConnector.run(flowQuery.update(self.rating <- flow.rating))
        try dbConnector.run(flowQuery.update(self.description <- flow.description))
    }
}
