//
//  Task.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Task{
    var hasID : Bool!
    
    var id : Int!{
        willSet(newValue){
            self.hasID = (newValue != nil) ? true : false
        }
    }
    var flowID : Int!
    
    var description : String!
    var isDone : Bool!
    
    public init(){
        self.description = ""
        self.isDone = false
        
        self.hasID = false
    }
    
    public init(_ id: Int, flowID : Int, description : String, isDone : Bool){
        self.id = id
        self.flowID = flowID
        self.description = description
        self.isDone = isDone
        
        self.hasID = true
    }
    
    public init(flowID : Int, description : String, isDone : Bool){
        self.flowID = flowID
        self.description = description
        self.isDone = isDone
        
        self.hasID = false
    }
}
