//
//  AddCardViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 06/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
    fileprivate var imagePath : String!
    let dateFormatter : DateFormatter = DateFormatter()
    var categoryList : [String] = ["a", "b", "c", "d"]
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileFlowImage: UIImageView!
    @IBOutlet weak var titleFieldLabel: UILabel!
    @IBOutlet weak var categoryFieldLabel: UILabel!
    @IBOutlet weak var authorFieldLabel: UILabel!
    @IBOutlet weak var releaseDateFieldLabel: UILabel!
    @IBOutlet weak var descriptionFieldLabel: UILabel!
    @IBOutlet weak var scrollFieldForm: UIScrollView!
    @IBOutlet weak var releaseDateField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var descriptionAreaEdit: UITextView!
    @IBOutlet weak var cardImageView: UIImageView!
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
    
    @objc func datePickerValueChanged(sender : UIDatePicker){
        releaseDateField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func categoryEditing(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        sender.inputView = pickerView
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
    
    
    @IBAction func chooseImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable((.savedPhotosAlbum)){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
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
