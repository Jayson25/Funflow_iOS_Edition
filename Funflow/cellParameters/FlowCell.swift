//
//  CardCell.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class FlowCell: UITableViewCell {
    
    var flowImage : UIImageView!
    var titleLabel : UILabel!
    var progressBar : UICircularProgressBar!
    var starRating : CosmosView!
    var whiteRoundedView : UIView!
    
    private var flowID : Int!
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.x += GenericSettings.rowSpacing/2
            frame.size.width -= GenericSettings.rowSpacing
            super.frame = frame
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func assignFlowIDOnCell(id : Int){
        self.flowID = id
    }
    
    func initialize(){
        
        self.whiteRoundedView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.height - 20, height: self.frame.height - 20))
        self.flowImage = UIImageView()
        self.titleLabel = UILabel()
        self.starRating = CosmosView()
        self.progressBar = UICircularProgressBar(frame: CGRect(x: 0, y: 0, width: self.whiteRoundedView.frame.height, height: self.whiteRoundedView.frame.height))
        
        self.contentView.addSubview(self.whiteRoundedView)
        self.contentView.addSubview(self.flowImage)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.progressBar)
        self.contentView.addSubview(self.starRating)
        
        self.contentView.sendSubviewToBack(self.whiteRoundedView)
        GenericSettings.applyLayout(forView: self.whiteRoundedView)
        
        self.whiteRoundedView.translatesAutoresizingMaskIntoConstraints = false
        self.flowImage.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.starRating.translatesAutoresizingMaskIntoConstraints = false
        self.progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        GenericSettings.applyLayout(forView: self.flowImage)
        
        self.titleLabel.textColor = GenericSettings.fontColor
        self.titleLabel.font = UIFont(name: GenericSettings.fontStyle, size: GenericSettings.fontNormalSize)
        
        self.progressBar.transform = self.progressBar.transform.rotated(by: CGFloat.pi / -2)
        
        self.starRating.filledColor = GenericSettings.themeColor
        self.starRating.filledBorderColor = GenericSettings.themeColor
        self.starRating.emptyBorderColor = GenericSettings.themeColor
        self.starRating.settings.updateOnTouch = false
        self.starRating.rating = 5
        self.starRating.starSize = 30
        self.starRating.settings.fillMode = .full
        self.starRating.settings.starMargin = 10
        
        self.flowImage?.image = UIImage(named: "image_icon")?.withRenderingMode(.alwaysTemplate)
        self.flowImage?.contentMode = .scaleAspectFit
        
        let whiteRoundedViewCenterYConstraint = NSLayoutConstraint(
            item: self.whiteRoundedView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        let whiteRoundedViewLeftConstraint = NSLayoutConstraint(
            item: self.whiteRoundedView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 10.0)
        
        let whiteRoundedViewRightConstraint = NSLayoutConstraint(
            item: self.whiteRoundedView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -10.0)
        
        let whiteRoundedViewHeightConstraint = NSLayoutConstraint(
            item: self.whiteRoundedView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.frame.height - 10)
        
        let flowImageLeftConstraint = NSLayoutConstraint(
            item: self.flowImage,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.whiteRoundedView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 5.0)
        
        let flowImageWidthConstraint = NSLayoutConstraint(
            item: self.flowImage,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.whiteRoundedView.frame.height)
        
        let flowImageHeightConstraint = NSLayoutConstraint(
            item: self.flowImage,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.whiteRoundedView.frame.height)
        
        let flowImageCenterYConstraint = NSLayoutConstraint(
            item: self.flowImage,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.whiteRoundedView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        let titleLabelCenterYConstraint = NSLayoutConstraint(
            item: self.titleLabel,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.whiteRoundedView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        let titleLabeLefttConstraint = NSLayoutConstraint(
            item: self.titleLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.flowImage,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 10.0)
        
        let titleLabelHeightConstraint = NSLayoutConstraint(
            item: self.titleLabel,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 25.0)
        
        let starRatingCenterYConstraint = NSLayoutConstraint(
            item: self.starRating,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.whiteRoundedView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        let starRatingRightConstraint = NSLayoutConstraint(
            item: self.starRating,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.progressBar,
            attribute: .leading,
            multiplier: 1.0,
            constant: -(self.starRating.frame.width - self.progressBar.frame.width + 20))
        
        let starRatingWidthConstraint = NSLayoutConstraint(
            item: self.starRating,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 75.0)
        
        let starRatingHeightConstraint = NSLayoutConstraint(
            item: self.starRating,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 30.0)
        
        let progressBarRightConstraint = NSLayoutConstraint(
            item: self.progressBar,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.whiteRoundedView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -5.0)
        
        let progressCenterYConstraint = NSLayoutConstraint(
            item: self.progressBar,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self.whiteRoundedView,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0.0)
        
        let progressWidthConstraint = NSLayoutConstraint(
            item: self.progressBar,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.whiteRoundedView.frame.height-2)
        
        let progressHeightConstraint = NSLayoutConstraint(
            item: self.progressBar,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.whiteRoundedView.frame.height-2)
        
        NSLayoutConstraint.activate([
            whiteRoundedViewCenterYConstraint, whiteRoundedViewLeftConstraint, whiteRoundedViewRightConstraint, whiteRoundedViewHeightConstraint,
            flowImageLeftConstraint, flowImageWidthConstraint, flowImageHeightConstraint, flowImageCenterYConstraint,
            titleLabelHeightConstraint, titleLabeLefttConstraint, titleLabelCenterYConstraint,
            starRatingCenterYConstraint, starRatingRightConstraint, starRatingWidthConstraint, starRatingHeightConstraint,
            progressCenterYConstraint, progressWidthConstraint, progressHeightConstraint, progressBarRightConstraint
        ])
    }
}
