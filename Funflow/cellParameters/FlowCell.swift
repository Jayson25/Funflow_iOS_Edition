//
//  CardCell.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class FlowCell: UITableViewCell, ComponentLayout {
    
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
    
    @IBOutlet weak var logoCard: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignFlowIDOnCell(id : Int){
        self.flowID = id
    }
}
