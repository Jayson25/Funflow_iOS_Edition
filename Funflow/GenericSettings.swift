//
//  ConfigurationParam.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class GenericSettings{
    static let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.60, alpha: 1.0)
    static let genericCornerRadius : CGFloat = 10
    static let fieldCornerRadius : CGFloat = 15
    static let translucidOpacity : CGFloat = 0.5
    static let borderWidth : CGFloat = 0.5
    static let rowSpacing : CGFloat = 10.0
    static let backgroundColor : UIColor = UIColor.init(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
    static let whiteMaterialColor : UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: GenericSettings.translucidOpacity)
    static let fontColor : UIColor = UIColor.init(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    static let documentFolder : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static var imageFolder : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("img")
    
    //   D <name : icon>
    static let categories : [Int : [String : String]] = [
        0: ["Video Games" : "video_games"],
        1: ["Movies" : "movie"],
        2: ["TV Series" : "tv_series"],
        3: ["Music" : "music"],
        4: ["Books" : "read"],
        5: ["Japanese Culture" : "japan_culture"],
        6: ["Travel & Culture" : "travel"],
        7: ["Others" : "others"]
    ]
    
    //function written by https://www.otz.li/author/cwolf/
    static func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }
            
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
            
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
       return normalizedImage
    }
}
