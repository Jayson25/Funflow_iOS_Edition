//
//  ComponentLayout.swift
//  Funflow
//
//  Created by Jayson Galante on 08/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

protocol ComponentLayout{
    func initializeLayout()
}

extension ComponentLayout where Self: UIView{
    
    func initializeLayout(){
        self.layer.cornerRadius = GenericSettings.fieldCornerRadius
        self.clipsToBounds = true
        self.layer.borderWidth = GenericSettings.borderWidth
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.backgroundColor = GenericSettings.whiteMaterialColor
    }
}
