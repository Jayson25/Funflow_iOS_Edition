//
//  CardCell.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
    
    private var cardID : Int!
    
    @IBOutlet weak var logoCard: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func assignCardIDOnCell(id : Int){
        self.cardID = id
    }
}
