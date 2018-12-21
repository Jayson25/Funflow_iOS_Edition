//
//  AddCardViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 06/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate {
 
    fileprivate var imagePath : String!
    let dateFormatter : DateFormatter = DateFormatter()
    var categoryList : [String] = ["a", "b", "c", "d"]
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var titleFieldLabel: UILabel!
    @IBOutlet weak var categoryFieldLabel: UILabel!
    @IBOutlet weak var authorFieldLabel: UILabel!
    @IBOutlet weak var releaseDateFieldLabel: UILabel!
    @IBOutlet weak var descriptionFieldLabel: UILabel!
    
    @IBOutlet weak var scrollFieldForm: UIScrollView!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var releaseDateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    
    @IBOutlet weak var profileFlowImage: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var descriptionAreaEdit: UITextView!
    
    @IBOutlet weak var formContentView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var browseImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardImageView.backgroundColor = UIColor.white
        cardImageView.image = #imageLiteral(resourceName: "nc_test")
        cardImageView.layer.cornerRadius = ConfigurationParam.roundedCorners
        
        self.formContentView.backgroundColor = ConfigurationParam.backgroundColor
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        releaseDateField.delegate = self
        categoryField.delegate = self
        authorField.delegate = self
        
        descriptionAreaEdit.text = ""
        descriptionAreaEdit.layer.cornerRadius = ConfigurationParam.roundedCorners
        descriptionAreaEdit.delegate = self
        
        titleFieldLabel.textColor = ConfigurationParam.fontColor
        categoryFieldLabel.textColor = ConfigurationParam.fontColor
        authorFieldLabel.textColor = ConfigurationParam.fontColor
        releaseDateFieldLabel.textColor = ConfigurationParam.fontColor
        descriptionFieldLabel.textColor = ConfigurationParam.fontColor
        
        let date = Date()
        releaseDateField.text = dateFormatter.string(from: date)
    }
    
    @IBAction func releaseDateEditing(_ sender: UITextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    @IBAction func categoryEditing(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sender.inputView = pickerView
    }
    
    @IBAction func chooseImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable((.savedPhotosAlbum)){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveFlowAction(_ sender: Any) {
        let title : String = titleField.text!
        let category : String = categoryField.text!
        let author : String = authorField.text!
        let releaseDate : String = releaseDateField.text!
        let description : String = descriptionAreaEdit.text!
        var image : String!
        
        /**save Image to folder app system
        */
        
        let documentFolder : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imgFolderPath : URL = documentFolder.appendingPathComponent("FunFlow").appendingPathComponent("img")
        
        if (profileFlowImage.image != nil){
            //create folders if not exists
            do{
                try FileManager.default.createDirectory(atPath: imgFolderPath.path, withIntermediateDirectories: true, attributes: nil)
                
                //generate name for the profile image
                let letters = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                image = String((0...20).map{_ in letters.randomElement()!}) + ".png"
                let imgPath : URL = imgFolderPath.appendingPathComponent(image)
                
                //save image to file
                if let png = profileFlowImage.image?.pngData(){
                    do {
                        try png.write(to: imgPath)
                    }
                    
                    catch let error as NSError{
                        NSLog("Could not save profile image to app folder \(error.debugDescription)")
                    }
                }
                
                else{
                    print("could not extract UIImage to PNG data")
                }
            }
            
            catch let error as NSError{
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }

        resetForm()
        
        //need to save datas to DB next
    }
    
    @IBAction func cancelFormAction(_ sender: Any) {
        resetForm()
    }
    
    
    @objc func datePickerValueChanged(sender : UIDatePicker){
        releaseDateField.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = categoryList[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileFlowImage.contentMode = .scaleAspectFit
            profileFlowImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        let scrollPoint : CGPoint = CGPoint(x: 0, y: textView.frame.origin.y)
        self.scrollFieldForm.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollFieldForm.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint : CGPoint = CGPoint(x: 0, y: textField.frame.origin.y)
        self.scrollFieldForm.setContentOffset(scrollPoint, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollFieldForm.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func resetForm(){
        let date = Date()
        
        releaseDateField.text = dateFormatter.string(from: date)
        titleField.text = ""
        categoryField.text = ""
        authorField.text = ""
        descriptionAreaEdit.text = ""
    }
}

/*
    Those two extensions allows to close the input view (keyboard, etc...)
    when user touches somewhere else on screen
*/

extension UIViewController{
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UIScrollView{
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}
