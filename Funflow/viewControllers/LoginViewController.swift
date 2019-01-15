//
//  LoginViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 12/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit
import LocalAuthentication
import BEMCheckBox

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var rePasswordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextFieldLayout!
    @IBOutlet weak var rePasswordField: UITextFieldLayout!
    @IBOutlet weak var consentCheckbox: BEMCheckBox!

    private var dbController : DBController!
    var isUserSetup : Bool!
    
    var errorAlert : UIAlertController!
    var successAlert : UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorAlert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        self.errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.successAlert = UIAlertController(title: "Sucess", message: nil, preferredStyle: .alert)
        
        let successOKAction = UIAlertAction(title: "OK", style: .default){
            action -> Void in
            self.performSegue(withIdentifier: "unlockApp", sender: self)
        }
        
        self.successAlert.addAction(successOKAction)
        
        self.backgroundImage.image = UIImage(named: "main_background.jpg")
        
        self.mainTitle.textColor = GenericSettings.themeColor
        
        GenericSettings.applyLayout(forView: self.loginView)
        self.loginView.backgroundColor = GenericSettings.backgroundColor
        self.loginView.alpha = 0.95
        
        self.passwordField.isSecureTextEntry = true
        self.rePasswordField.isSecureTextEntry = true
        self.passwordField.layer.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        self.rePasswordField.layer.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        self.consentCheckbox.onAnimationType = BEMAnimationType.stroke
        self.consentCheckbox.offAnimationType = BEMAnimationType.stroke
        
        GenericSettings.applyLayout(forView: self.authButton)
        self.authButton.layer.borderColor = GenericSettings.themeColor.cgColor
        
        do{
            self.dbController = try DBController()
            self.isUserSetup = try dbController.userDAO.isUserSetup()
            
            if (self.isUserSetup){
                
                self.rePasswordLabel.isHidden = true
                self.rePasswordField.isHidden = true
                
                
                if (try dbController.userDAO.isBiometrics()){
                    unlockBiometrics()
                }
            }
        }
        
        catch{
            print(error)
        }
    }

    @IBAction func startLogin(_ sender: Any) {
        do{
            if (self.isUserSetup){
                if (try dbController.userDAO.comparePassword(forPwd: passwordField.text!)){
                    self.performSegue(withIdentifier: "unlockApp", sender: self)
                }
                
                else{
                    self.errorAlert.message = "passwords incorrect"
                    present(self.errorAlert, animated: true, completion: nil)
                }
            }
            
            else{
                try createUser()
            }
        }
        
        catch{
            print(error)
        }
    }
    
    private func createUser() throws{
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        if (self.passwordField.text?.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil){
            if (self.passwordField.text == self.rePasswordField.text){
                if (consentCheckbox.on){
                    try dbController.userDAO.insert(forPwd: passwordField.text!)
                    self.successAlert.message = "Password created"
                    self.present(self.successAlert, animated: true, completion: nil)
                }
                
                else{
                    self.errorAlert.message = "Please check the data consent checkbox"
                    present(self.errorAlert, animated: true, completion: nil)
                }
            }
            
            else{
                self.errorAlert.message = "passwords doesn't matches, please try again"
                present(self.errorAlert, animated: true, completion: nil)
            }
        }
        
        else{
            self.errorAlert.message = "Password must must 1 letter, 1 number, and minimum length 8"
            present(self.errorAlert, animated: true, completion: nil)
        }
    }
    
    private func unlockBiometrics(){
        if #available(iOS 9.0, *) {
            let context = LAContext()
            let reason = "put your finger on touchID to unlock Funflow"
            
            var authError : NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                    [unowned self] success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if (success){
                            self.performSegue(withIdentifier: "unlockApp", sender: self)
                        }
                    }
                }
            }
        }
    }
}
