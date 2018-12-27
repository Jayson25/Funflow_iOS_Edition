//
//  ConfigurationParam.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import Foundation
import UIKit

class ConfigurationParam{
    static let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.60, alpha: 1.0)
    static let roundedCorners : CGFloat = 6
    static let backgroundColor : UIColor = UIColor.init(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
    static let fontColor : UIColor = UIColor.init(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    
    static let categories : [Category] = [
        Category(name: "Video Games", icon: "video_games"),
        Category(name: "Movies", icon: "movie"),
        Category(name: "TV Series", icon: "tv_series"),
        Category(name: "Music", icon: "music"),
        Category(name: "Books", icon: "read"),
        Category(name: "Japanese Culture", icon: "japan_culture"),
        Category(name: "Travel & Culture", icon: "travel"),
        Category(name: "Others", icon: "others"),
        Category(name: "All", icon: "")
    ]
}
