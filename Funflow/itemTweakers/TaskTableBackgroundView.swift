//
//  TaskTableBackgroundView.swift
//  Funflow
//
//  Created by Jayson Galante on 29/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class TaskTableBackgroundView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var imageView: UIImageView!
    private var topLabel: UILabel!
    private var bottomLabel: UILabel!
    
    private let topColor = UIColor.darkGray
    private let topFont = UIFont.boldSystemFont(ofSize: 17)
    private let bottomColor = UIColor.gray
    private let bottomFont = UIFont.systemFont(ofSize: 14)
    
    private let spacing: CGFloat = 10
    private let imageViewSize: CGFloat = 125
    private let bottomLabelWidth: CGFloat = 300
    
    var didSetupConstraints = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    init(image: UIImage, top: String, bottom: String){
        super.init(frame: CGRect.zero)
        self.setupViews()
        setupImageView(image: image)
        setupLabels(top: top, bottom: bottom)
    }
    
    func setupViews(){
        self.imageView = UIImageView()
        self.topLabel = UILabel()
        self.bottomLabel = UILabel()
        
        addSubview(self.imageView)
        addSubview(self.topLabel)
        addSubview(self.bottomLabel)
    }
    
    func setupImageView(image: UIImage){
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = image
        imageView.tintColor = ConfigurationParam.themeColor
    }
    
    func setupLabels(top: String, bottom: String){
        self.topLabel.text = top
        self.topLabel.textColor = topColor
        self.topLabel.font = topFont
        
        self.bottomLabel.text = bottom
        self.bottomLabel.textColor = bottomColor
        self.bottomLabel.font = bottomFont
        self.bottomLabel.textAlignment = .center
    }
    
    override func updateConstraints() {
        if !self.didSetupConstraints {

            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.topLabel.translatesAutoresizingMaskIntoConstraints = false
            self.bottomLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let imageViewCenterYConstraint = NSLayoutConstraint(
                item: self.imageView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0
            )
            
            let imageViewCenterXConstraint = NSLayoutConstraint(
                item: self.imageView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0
            )
            
            let imageViewHeightConstraint = NSLayoutConstraint(
                item: self.imageView,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: self.imageViewSize
            )
            
            let imageViewWidthConstraint = NSLayoutConstraint(
                item: self.imageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: self.imageViewSize
            )
            
            let topLabelCenterXConstraint = NSLayoutConstraint(
                item: self.topLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0
            )
            
            let topLabelTopConstraint = NSLayoutConstraint(
                item: self.topLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: self.imageView,
                attribute: .bottom,
                multiplier: 1.0,
                constant: self.spacing
            )
            
            let bottomLabelCenterXContraint = NSLayoutConstraint(
                item: self.bottomLabel,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0
            )
            
            let bottomLabelTopContraint = NSLayoutConstraint(
                item: self.bottomLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: self.topLabel,
                attribute: .bottom,
                multiplier: 1.0,
                constant: 0
            )
            
            let bottomLabelWidthConstraint = NSLayoutConstraint(
                item: self.bottomLabel,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: self.bottomLabelWidth
            )
            
            NSLayoutConstraint.activate([
                imageViewCenterYConstraint, imageViewCenterXConstraint, imageViewWidthConstraint, imageViewHeightConstraint,
                topLabelCenterXConstraint, topLabelTopConstraint,
                bottomLabelCenterXContraint, bottomLabelTopContraint, bottomLabelWidthConstraint
            ])
            
            self.didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
