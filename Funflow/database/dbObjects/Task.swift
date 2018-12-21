//
//  Task.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Task{
    private var id : Int!
    private var flowID : Int!
    private var description : String!
    private var isDone : Bool!
    
    public init(){}
    public init(id : Int, flowID : Int, description : String, isDone : Bool){
        self.id = id
        self.flowID = flowID
        self.description = description
        self.isDone = isDone
    }
    
    public func getID() -> Int{
        return self.id
    }
    
    public func getFlowID() -> Int{
        return self.flowID
    }
    
    public func getDescription() -> String{
        return self.description
    }
    
    public func isItDone() -> Bool{
        return self.isDone
    }
    
    public func setID(_ id : Int){
        self.id = id
    }
    
    public func setFlowID(_ flowID : Int){
        self.flowID = flowID
    }
    
    public func setDescription(_ description : String){
        self.description = description
    }
    
    public func setDone(_ done : Bool){
        self.isDone = done
    }
}
