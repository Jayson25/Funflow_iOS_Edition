//
//  SettingsViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 13/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var fpIcon: UIImageView!
    @IBOutlet weak var fpLabel: UILabel!
    @IBOutlet weak var fpSwitch: UISwitch!
    
    
    @IBOutlet weak var settingsWhiteView: UIView!
    
    @IBOutlet weak var pwdButton: UIScrollView!
    
    @IBOutlet weak var passwordField: UITextFieldLayout!
    @IBOutlet weak var rePasswordField: UITextFieldLayout!
    
    private var dbController : DBController!
    
    var errorAlert : UIAlertController!
    var successAlert : UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GenericSettings.backgroundColor
        
        GenericSettings.applyLayout(forView: self.settingsWhiteView)
        
        self.errorAlert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        self.errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.successAlert = UIAlertController(title: "Sucess", message: nil, preferredStyle: .alert)
        self.successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        do{
            self.dbController = try DBController()
        }
        
        catch {
            print(error)
        }
        
        self.passwordField.isSecureTextEntry = true
        self.rePasswordField.isSecureTextEntry = true
        
        GenericSettings.applyLayout(forView: self.pwdButton)
        self.pwdButton.layer.borderColor = GenericSettings.themeColor.cgColor

        // Do any additional setup after loading the view.
        self.fpIcon?.image = UIImage(named: "fprint")?.withRenderingMode(.alwaysTemplate)
        
        if #available(iOS 9.0, *) {
            let context = LAContext()
            var authError : NSError?
            
            let fp = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)
            showFpSettings(fp)
            
        }
        
        else{
            showFpSettings(false)
        }
    }
    

    private func showFpSettings(_ isFp : Bool){
        self.fpIcon.isHidden = !isFp
        self.fpLabel.isHidden = !isFp
        self.fpSwitch.isHidden = !isFp
        
        do{
            try self.fpSwitch.isOn = self.dbController.userDAO.isBiometrics()
        }
        
        catch{
            print(error)
        }
    }
    
    private func checkBiometrics(){
        if #available(iOS 9.0, *) {
            let context = LAContext()
            let reason = "put your finger on touchID to unlock Funflow"
            
            var authError : NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                    [unowned self] success, evaluateError in
                    
                    DispatchQueue.main.async{
                        if (success){
                            do {
                                try self.dbController.userDAO.updateBiometrics(isOn: success)
                                
                                self.successAlert.message = "Fingerprint authentication sucessfully set"
                                self.present(self.successAlert, animated: true, completion: nil)
                            }
                                
                            catch{
                                print(error)
                            }
                        }
                            
                        else{
                            self.fpSwitch.setOn(false, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        if (self.passwordField.text?.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil){
            if (self.passwordField.text == self.rePasswordField.text){
                do{
                    try dbController.userDAO.updatePassword(newPassword: self.passwordField.text!)

                    self.successAlert.message = "Password changed"
                    self.present(self.successAlert, animated: true, completion: nil)
                    
                    self.passwordField.text = ""
                    self.rePasswordField.text = ""
                }
                
                catch{
                    self.errorAlert.message = "could not retrieve password in database, contact developer"
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
    
    @IBAction func setFingerPrint(_ sender: UISwitch) {
        if (sender.isOn == true){
            checkBiometrics()
        }
        
        else{
            do {
                try self.dbController.userDAO.updateBiometrics(isOn: false)
            }
                
            catch{
                print(error)
            }
        }
    }
}
