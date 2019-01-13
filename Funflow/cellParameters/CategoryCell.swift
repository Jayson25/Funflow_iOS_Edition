//
//  CategoryCell.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    var categoryIcon: UIImageView!
    var clickable: UIButton!
    var categoryTitle : UILabel!
    //var category : String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        GenericSettings.applyLayout(forView: self)
        initCellLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        GenericSettings.applyLayout(forView: self)
        initCellLayout()
    }
    
    func initCellLayout(){
        self.contentView.backgroundColor = .clear
        
        self.categoryIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.categoryTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.clickable = UIButton(frame: CGRect(x:0, y:0, width: 0, height: 0))
        
        self.categoryIcon.contentMode = UIView.ContentMode.scaleAspectFit
        self.categoryTitle.textAlignment = .center
        
        self.contentView.addSubview(self.clickable)
        self.contentView.addSubview(self.categoryTitle)
        self.contentView.addSubview(self.categoryIcon)
        
        self.categoryTitle.textColor = GenericSettings.themeColor
        self.categoryTitle.font = UIFont(name: GenericSettings.fontStyle, size: 18.0)
        
        self.clickable?.translatesAutoresizingMaskIntoConstraints = false
        self.categoryIcon.translatesAutoresizingMaskIntoConstraints = false
        self.categoryTitle.translatesAutoresizingMaskIntoConstraints = false
        
        let iconLeftConstraint = NSLayoutConstraint(
            item: self.categoryIcon,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 20.0
        )
        
        let iconRightConstraint = NSLayoutConstraint(
            item: self.categoryIcon,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -20.0
        )
        
        let iconTopConstraint = NSLayoutConstraint(
            item: self.categoryIcon,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .top,
            multiplier: 1.0,
            constant: 20.0
        )
        
        let iconBottomConstraint = NSLayoutConstraint(
            item: self.categoryIcon,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.categoryTitle,
            attribute: .top,
            multiplier: 1.0,
            constant: -15.0
        )
        
        let titleRightConstraint = NSLayoutConstraint(
            item: self.categoryTitle,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 5.0
        )
        
        let titleLeftConstraint = NSLayoutConstraint(
            item: self.categoryTitle,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 5.0
        )
        
        let titleBottomConstraint = NSLayoutConstraint(
            item: self.categoryTitle,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: -10.0
        )
        
        let titleHeightConstraint = NSLayoutConstraint(
            item: self.categoryTitle,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 25.0
        )
        
        let clickableTopConstraint = NSLayoutConstraint(
            item: self.clickable,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let clickableBottomConstraint = NSLayoutConstraint(
            item: self.clickable,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let clickableLeftConstraint = NSLayoutConstraint(
            item: self.clickable,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let clickableRightConstraint = NSLayoutConstraint(
            item: self.clickable,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0
        )
        
        NSLayoutConstraint.activate([
            iconTopConstraint, iconBottomConstraint, iconLeftConstraint, iconRightConstraint,
            titleLeftConstraint, titleRightConstraint, titleBottomConstraint, titleHeightConstraint,
            clickableTopConstraint, clickableBottomConstraint, clickableLeftConstraint, clickableRightConstraint
        ])
    }
}
