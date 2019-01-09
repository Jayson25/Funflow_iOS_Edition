//
//  Flow.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class Flow{
    
    private var _id : Int!
    
    var id : Int!{
        get{
            return self._id
        }
    }
    
    var title : String!
    var image : String!
    var category : String!
    var author : String!
    var releaseDate : String!
    var rating : Int!
    var description : String!
    
    public init(_ id: Int, title: String, image: String, category: String, author: String, releaseDate: String, rating: Int, description: String){
        self._id = id
        self.title = title
        self.image = image
        self.category = image
        self.author = author
        self.releaseDate = releaseDate
        self.rating = rating
        self.description = description
    }
    
    public init(title: String, image: String, category: String, author: String, releaseDate: String, rating: Int, description: String){
        self.title = title
        self.image = image
        self.category = image
        self.author = author
        self.releaseDate = releaseDate
        self.rating = rating
        self.description = description
    }
}


