//
//  Task.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Task{
    private var flowID : Int!
    private var description : String!
    private var isDone : Bool!
    
    public init(){
        self.description = ""
        self.isDone = false
    }
    
    public init(flowID : Int, description : String, isDone : Bool){
        self.flowID = flowID
        self.description = description
        self.isDone = isDone
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
