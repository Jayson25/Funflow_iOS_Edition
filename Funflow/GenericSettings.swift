//
//  ConfigurationParam.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit
import LocalAuthentication

struct GenericSettings{
    static let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.60, alpha: 1.0)
    static let genericCornerRadius : CGFloat = 10
    static let fieldCornerRadius : CGFloat = 15
    static let translucidOpacity : CGFloat = 0.5
    static let borderWidth : CGFloat = 0.5
    static let rowSpacing : CGFloat = 10.0
    static let fontStyle = "Devanagari Sangam MN"
    static let fontNormalSize : CGFloat = 17.0
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
    static func fixOrientation(img: UIImage) -> UIImage? {
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
    
    static func resizeImage(image: UIImage?, targetSize: CGSize) ->  UIImage? {
        if (image == nil){
            return nil
        }
        
        let size = image?.size
        
        let widthRatio = targetSize.width / (size?.width)!
        let heightRatio = targetSize.height / (size?.height)!
        
        var newSize: CGSize
        if (widthRatio > heightRatio){
            newSize = CGSize(width: (size?.width)! * heightRatio, height: (size?.height)! * heightRatio)
        }
        
        else{
            newSize = CGSize(width: (size?.width)! * widthRatio, height: (size?.height)! * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static func applyLayout(forView view : UIView) {
        view.layer.cornerRadius = GenericSettings.fieldCornerRadius
        view.clipsToBounds = true
        view.layer.borderWidth = GenericSettings.borderWidth
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.backgroundColor = GenericSettings.whiteMaterialColor
    }
    
    static func authBiometrics() -> Bool{
        
        if #available(iOS 9.0, *) {
            let context = LAContext()
            let reason = "put your finger on touchID to unlock Funflow"
            
            var authError : NSError?
            var isAuth : Bool = false
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                    (success, evaluateError) in
                    if (success){
                        //return true
                    }
                    
                    else{
                       // return false
                    }
                }
            }
            
            return isAuth
        }
        
        return false
    }
    
    /*static func isRegexMatch(for regex : String, in text: String) -> Bool {
        do{
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String (text)
            }
        }
        
        catch {
            return false
        }
    }*/
}
