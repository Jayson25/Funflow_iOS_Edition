//
//  Category.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Category{
    private var id : Int!
    private var name : String!
    private var icon : String!
    
    public init(){}
    public init(id : Int, name : String, icon : String){
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    public func getID() -> Int{
        return self.id
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getIcon() -> String{
        return self.icon
    }
    
    public func setID(_ id : Int){
        self.id = id
    }
    
    public func setName(_ name : String){
        self.name = name
    }
    
    public func setIcon(_ icon : String){
        self.icon = icon
    }
}
