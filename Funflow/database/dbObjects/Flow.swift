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
    
    var uiImage : UIImage?
    var image : String!{
        willSet(newValue){
            print("hit or miss ", newValue)
            updateUIImage(newValue)
        }
    }
    
    var category : String!
    var author : String!
    var releaseDate : String!
    var rating : Int!
    var description : String!
    var progress : Float!
    
    public init(_ id: Int, title: String, image: String, category: String, author: String, releaseDate: String, rating: Int, description: String){
        self._id = id
        self.title = title
        self.image = image
        self.category = category
        self.author = author
        self.releaseDate = releaseDate
        self.rating = rating
        self.description = description
        
        updateUIImage(image)
        updateProgress()
    }
    
    public init(title: String, image: String, category: String, author: String, releaseDate: String, rating: Int, description: String){
        self.title = title
        self.image = image
        self.category = category
        self.author = author
        self.releaseDate = releaseDate
        self.rating = rating
        self.description = description
        
        updateUIImage(image)
        updateProgress()
    }
    
    private func updateUIImage(_ image : String){
        
        if (image != "") {
            let folder : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL : URL = folder.appendingPathComponent("DCIM").appendingPathComponent(image)
            
            autoreleasepool{() -> () in
                self.uiImage = UIImage(contentsOfFile: imageURL.path)
            }
        }
    }
    
    func updateProgress(){
        if (self.id != nil){
            let dbController : DBController
            do{
                dbController = try DBController()
                let tasks : [Task] = try dbController.taskDAO.select(flowID: self.id)
                let total : Float = Float(tasks.count)
                let completed : Float = Float(tasks.filter({$0.isDone == true}).count)
                
                self.progress = completed / total
            }
            
            catch{
                print(error)
            }
        }
    }
}
