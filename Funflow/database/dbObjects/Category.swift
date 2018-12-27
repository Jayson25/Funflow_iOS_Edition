//
//  Category.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Category{
    private var name : String!
    private var icon : String!
    
    public init(){}
    public init(name : String, icon : String){
        self.name = name
        self.icon = icon
    }
    
    public func getName() -> String{
        return self.name
    }
    
    public func getIcon() -> String{
        return self.icon
    }
    
    public func setName(_ name : String){
        self.name = name
    }
    
    public func setIcon(_ icon : String){
        self.icon = icon
    }
}
