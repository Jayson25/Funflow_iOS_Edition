//
//  CategoryCell.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var buttonZone: UIButton!
    @IBOutlet weak var categoryTitle : UILabel!
    
    @IBAction func onClick(_ sender: Any) {
        print("button ", buttonZone.tag)
    }
    
    
}
