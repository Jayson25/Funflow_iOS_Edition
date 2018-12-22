//
//  ImagePickerManager.swift
//  Funflow
//
//  Created by Jayson Galante on 21/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import Foundation
import UIKit

class ImagerPickerManager : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imgPicker = UIImagePickerController()
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var button : UIButton!
    var viewController : UIViewController?
    var pickImageCallback : ((UIImage) -> ())?
    
    init(_ button : UIButton){
        super.init()
        self.button = button
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())){
        pickImageCallback = callback
        self.viewController = viewController
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            action -> Void in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Galery", style: .default) {
            action -> Void in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            action -> Void in
        }
        
        imgPicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.button
        alert.popoverPresentationController?.sourceRect = self.button.bounds
        alert.modalPresentationStyle = .popover
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imgPicker.sourceType = .camera
            self.viewController!.present(imgPicker, animated: true, completion: nil)
        }
            
        else{
            let alertWarning = UIAlertController(title: "Warning", message: "you don't have a camera", preferredStyle: UIAlertController.Style.alert)
            
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default){
                UIAlertAction in
            })
            
            self.viewController!.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)){
            imgPicker.sourceType = .photoLibrary
            self.viewController!.present(imgPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imgPicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else{
            fatalError("Expected a dictionay containing an image, but was proven the following: \(info)")
        }
        pickImageCallback?(image)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?){
    }
}
