//
//  TaskCell.swift
//  Funflow
//
//  Created by Jayson Galante on 27/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit
import BEMCheckBox

class TaskCell: UITableViewCell {
    
    var checkbox : BEMCheckBox!
    var taskLabel : UILabel!
    var isDone = false
    
    override func awakeFromNib()  {
        //super.awakeFromNib()
        //super.init(style: UITableViewCell.CellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        self.taskLabel = UILabel(frame: CGRect(x: 20.0, y: 3.0, width: 0.0, height: 0.0))
        self.checkbox = BEMCheckBox(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.contentView.addSubview(checkbox)
        self.contentView.addSubview(taskLabel)

        taskLabel.text = "j'ai mal au petit pois"

        self.checkbox.setOn(false, animated: true)
        self.checkbox.onAnimationType = BEMAnimationType.stroke
        self.checkbox.offAnimationType = BEMAnimationType.stroke
        
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.taskLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let centerYCBConstraint = NSLayoutConstraint(
            item: self.checkbox,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self.contentView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let leftCBConstraint = NSLayoutConstraint(
            item: self.checkbox,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .leading,
            multiplier: 1.0,
            constant: 20.0
        )
        
        let widthCBConstraint = NSLayoutConstraint(
            item: self.checkbox,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil, 
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.contentView.frame.height
        )
        
        let heightCBConstraint = NSLayoutConstraint(
            item: self.checkbox,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.contentView.frame.height
        )
        
        let centerYTLabelConstraint = NSLayoutConstraint(
            item: self.taskLabel,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self.contentView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let leftTLabelConstraint = NSLayoutConstraint(
            item: self.taskLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.checkbox,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 20.0
        )
        
        let rightTLabelConstraint = NSLayoutConstraint(
            item: self.taskLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 20.0
        )
        
        let heightTLabelConstraint = NSLayoutConstraint(
            item: self.taskLabel,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.contentView.frame.height
        )
        
       // let centerYLabel = NSLayoutConstraint(item: taskLabel, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.contentView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
     //   let leftLabel = NSLayoutConstraint(item: taskLabel, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: checkbox, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 50)
        
        NSLayoutConstraint.activate([
            centerYCBConstraint,
            leftCBConstraint,
            widthCBConstraint,
            heightCBConstraint,
            centerYTLabelConstraint,
            leftTLabelConstraint,
            rightTLabelConstraint,
            heightTLabelConstraint
        ])
        
       // self.contentView.addConstraint(leftCB, widthCB)
    }
    
   /* required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
