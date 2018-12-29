//
//  TaskCell.swift
//  Funflow
//
//  Created by Jayson Galante on 27/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit
import BEMCheckBox

class TaskCell: UITableViewCell, UITextViewDelegate, BEMCheckBoxDelegate{
    
    var task : Task!
    var checkbox : BEMCheckBox!
    var taskTextView : UITextView!
    var isDone = false
    
    var isEditable : Bool = true {
        didSet {
            if isEditable {
                self.taskTextView.isEditable = true
            }
        
            else {
                self.taskTextView.isEditable = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.taskTextView.addObserver(self, forKeyPath: "contentSize", options: (NSKeyValueObservingOptions.new), context: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.taskTextView = UITextView(frame: CGRect(x: 20.0, y: 3.0, width: 0.0, height: 0.0))
        self.checkbox = BEMCheckBox(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.checkbox.delegate = self
        
        self.contentView.addSubview(self.checkbox)
        self.contentView.addSubview(self.taskTextView)

        self.taskTextView.delegate = self
        self.taskTextView.text = "edit text here"
        self.taskTextView.textContainer.maximumNumberOfLines = 1
        self.taskTextView.font = UIFont(name: (self.taskTextView.font?.fontName)!, size: 15)
        self.taskTextView.isScrollEnabled = false

        self.checkbox.setOn(false, animated: true)
        self.checkbox.onAnimationType = BEMAnimationType.stroke
        self.checkbox.offAnimationType = BEMAnimationType.stroke
        
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.taskTextView.translatesAutoresizingMaskIntoConstraints = false
        
        
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
        
        let centerYTTextViewConstraint = NSLayoutConstraint(
            item: self.taskTextView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: self.contentView,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let leftTLabelConstraint = NSLayoutConstraint(
            item: self.taskTextView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.checkbox,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 20.0
        )
        
        let rightTLabelConstraint = NSLayoutConstraint(
            item: self.taskTextView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .trailing,
            multiplier: 1.0,
            constant: -20.0
        )
        
        let heightTLabelConstraint = NSLayoutConstraint(
            item: self.taskTextView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: self.contentView.frame.height
        )
        
        
        NSLayoutConstraint.activate([
            //checkbox constraints
            centerYCBConstraint, leftCBConstraint, widthCBConstraint, heightCBConstraint,
            //label of cell constraints
            centerYTTextViewConstraint, leftTLabelConstraint, rightTLabelConstraint, heightTLabelConstraint
        ])
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.task.setDescription(textView.text)
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        self.task.setDone(checkbox.on)
    }
}
