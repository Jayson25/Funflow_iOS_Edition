//
//  buttonLayout.swift
//  Funflow
//
//  Created by Jayson Galante on 14/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

@IBDesignable
class buttonLayout: UIButton {
    
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var normalBorderColor : UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    @IBInspectable var normalBackgroundColor : UIColor? {
        didSet{
            setBgColorForState(color: normalBackgroundColor, forState: .normal)
        }
    }
    
    @IBInspectable var highlightedBorderColor : UIColor?
    @IBInspectable var highlightedBackgroundColor : UIColor? {
        didSet{
            setBgColorForState(color: highlightedBackgroundColor, forState: .highlighted)
        }
    }
    
    private func setBgColorForState(color : UIColor?, forState : UIControl.State){
        if color != nil {
            setBackgroundImage(UIImage.imageWithColor(color: color!), for: forState)
        }
        
        else {
            setBackgroundImage(nil, for: forState)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = ConfigurationParam.roundedCorners
        clipsToBounds = true
        
        if borderWidth > 0 {
            if state == .normal && !CGColor.compareWithColor(a: layer.borderColor!, b: (normalBorderColor?.cgColor)!){
                
                layer.borderColor = normalBackgroundColor?.cgColor
            }
            
            else if state == .highlighted && highlightedBorderColor != nil{
                layer.borderColor = highlightedBorderColor!.cgColor
            }
        }
    }
}

extension CGColor{
    func SelfCompareWithColor(other: CGColor) -> Bool {
        let approximateColor = other.converted(to: self.colorSpace!, intent: .defaultIntent, options: nil)
        
        return self == approximateColor
    }
    
    class func compareWithColor(a: CGColor, b: CGColor) -> Bool {
        let approximateColor = a.converted(to: b.colorSpace!, intent: .defaultIntent, options: nil)
        
        return b == approximateColor
    }
}

extension UIImage {
    class func imageWithColor(color : UIColor) -> UIImage{
        let rect : CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
}
