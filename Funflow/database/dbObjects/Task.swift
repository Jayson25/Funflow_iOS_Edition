//
//  Task.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Task{
    private var _flowID : Int!
    
    var flowID : Int!{
        get{
            return self._flowID
        }
    }
    
    var description : String!
    var isDone : Bool!
    
    public init(){
        self.description = ""
        self.isDone = false
    }
    
    public init(flowID : Int, description : String, isDone : Bool){
        self._flowID = flowID
        self.description = description
        self.isDone = isDone
    }
}
