//
//  UIFlowImageView.swift
//  Funflow
//
//  Created by Jayson Galante on 09/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

class UIFlowImageView: UIView {

    fileprivate let title = "No image found"
    fileprivate let backgroundImage : UIImage = UIImage(named: "image_icon")!.withRenderingMode(.alwaysTemplate)
    var message = "please insert a image here"
    
    var imageView : UIImageView!
    var backgroundView : FieldBackgroundView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        GenericSettings.applyLayout(forView: self)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GenericSettings.applyLayout(forView: self)
        initialize()
    }
    
    deinit {
        print("flowImageView deleted")
    }
    
    func initialize(){
        
        self.backgroundView = FieldBackgroundView(image: self.backgroundImage, top: self.title, bottom: self.message)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.addSubview(self.backgroundView)
        self.addSubview(self.imageView)
        self.sendSubviewToBack(self.backgroundView)
        
        self.backgroundView.backgroundColor = .clear
        self.imageView.backgroundColor = .clear
        self.imageView.contentMode = .scaleAspectFit
        
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundViewTopConstraint = NSLayoutConstraint(
            item: self.backgroundView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let backgroundViewBottomConstraint = NSLayoutConstraint(
            item: self.backgroundView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let backgroundViewLeftConstraint = NSLayoutConstraint(
            item: self.backgroundView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let backgroundViewRightConstraint = NSLayoutConstraint(
            item: self.backgroundView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let imageViewTopConstraint = NSLayoutConstraint(
            item: self.imageView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let imageViewBottomConstraint = NSLayoutConstraint(
            item: self.imageView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let imageViewLeftConstraint = NSLayoutConstraint(
            item: self.imageView,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let imageViewRightConstraint = NSLayoutConstraint(
            item: self.imageView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1.0,
            constant: 0.0
        )
        
        NSLayoutConstraint.activate( [
            backgroundViewTopConstraint, backgroundViewBottomConstraint, backgroundViewLeftConstraint, backgroundViewRightConstraint,
            imageViewTopConstraint, imageViewBottomConstraint, imageViewLeftConstraint, imageViewRightConstraint
        ])
    }
    
    func updateBackground(){
        if (self.imageView.image == nil) {
            self.backgroundView.isHidden = false
        }
        
        else{
            self.backgroundView.isHidden = true
        }
    }
}
