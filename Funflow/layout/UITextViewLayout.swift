//
//  UITextViewLayout.swift
//  Funflow
//
//  Created by Jayson Galante on 08/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

class UITextViewLayout: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        GenericSettings.applyLayout(forView: self)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        GenericSettings.applyLayout(forView: self)
    }
}
