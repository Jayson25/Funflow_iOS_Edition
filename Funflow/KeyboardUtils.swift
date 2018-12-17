//
//  KeyBoardUtils.swift
//  Funflow
//
//  Created by Jayson Galante on 13/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class KeyboardUtils{
    static var instance = KeyboardUtils()
    static let lastKeyBoardSize : CGSize = CGSize()
    
    init(){
        self._registerKeyboardHandler()
        KeyboardUtils.instance = self
    }
    
    private func _registerKeyboardHandler(){
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboard, object: nil)
    }
}
