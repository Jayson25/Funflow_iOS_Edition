//
//  TaskCell.swift
//  Funflow
//
//  Created by Jayson Galante on 27/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit
import BEMCheckBox

class TaskCell: UITableViewCell, UITextViewDelegate, BEMCheckBoxDelegate, UITextInputTraits {
    
    var progressView : UICircularProgressBar?
    
    var task : Task!{
        willSet(newValue){
            self.checkbox.setOn(newValue.isDone, animated: true)
            
            let description = newValue.description
            self.taskTextView.text = (description != nil && description != "") ? description : "tap here to edit"
            self.taskTextView.font = UIFont(name: (self.taskTextView.font?.fontName)!, size: 15)
        }
    }
    
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
        initCellContent()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initCellContent()
    }
    
    private func initCellContent(){
        self.selectionStyle = .none
        
        self.taskTextView = UITextView()
        self.checkbox = BEMCheckBox()
        self.checkbox.delegate = self
        
        self.contentView.addSubview(self.checkbox)
        self.contentView.addSubview(self.taskTextView)
        
        self.taskTextView.delegate = self
        self.taskTextView.textContainer.maximumNumberOfLines = 1
        self.taskTextView.isScrollEnabled = false
        self.taskTextView.autocorrectionType = .default

        self.checkbox.onAnimationType = BEMAnimationType.stroke
        self.checkbox.offAnimationType = BEMAnimationType.stroke
        
        self.checkbox.translatesAutoresizingMaskIntoConstraints = false
        self.taskTextView.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .clear
        self.taskTextView.backgroundColor = .clear

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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //selects all text when beginning editing
        DispatchQueue.main.async {
            self.taskTextView.selectAll(nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.task.description = textView.text
        updateTask()
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        self.task.isDone = checkbox.on
        updateTask()
    }
    
    private func updateTask(){
        if (self.task.hasID){
            do{
                let dbController = try DBController()
                try dbController.taskDAO.update(self.task.id, description: self.task.description, isDone: self.task.isDone)
                
                if (self.progressView != nil){
                    let flow = try dbController.flowDAO.selectByID(self.task.flowID)
                    self.progressView?.progress = flow.progress
                }
            }
            
            catch{
                print(error)
            }
        }
    }
}
