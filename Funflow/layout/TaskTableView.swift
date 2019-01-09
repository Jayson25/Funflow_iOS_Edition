//
//  TaskTableView.swift
//  Funflow
//
//  Created by Jayson Galante on 29/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class TaskTableView: UITableView, ComponentLayout {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let image : UIImage = UIImage(named: "tasks")!.withRenderingMode(.alwaysTemplate)
    private let tableViewTitle : String = "Tasks"
    private let tableViewEmptyMessage : String = "You don't have any tasks yet."
    
    func setupEmptyBackgroundView(){
        let emptyBGV = FieldBackgroundView(image: image, top: self.tableViewTitle, bottom: self.tableViewEmptyMessage)
        self.backgroundView = emptyBGV
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLayout()
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initializeLayout()
    }
}
