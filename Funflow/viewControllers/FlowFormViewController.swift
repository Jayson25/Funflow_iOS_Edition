//
//  AddCardViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 06/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit
import SQLite

class FlowFormViewController: Observable, UIPickerViewDelegate, UIPickerViewDataSource {

    fileprivate var imagePath : String!
    let dateFormatter: DateFormatter = DateFormatter()
    
    var dbController : DBController!
    var flow : Flow! = Flow()
    
    
    
    //labels for form
    @IBOutlet weak var titleFieldLabel: UIFieldLabel!
    @IBOutlet weak var categoryFieldLabel: UIFieldLabel!
    @IBOutlet weak var authorFieldLabel: UIFieldLabel!
    @IBOutlet weak var releaseDateFieldLabel: UIFieldLabel!
    @IBOutlet weak var descriptionFieldLabel: UIFieldLabel!
    @IBOutlet weak var RatingEditLabel: UIFieldLabel!
    
    //scroll view
    @IBOutlet weak var scrollFieldForm: UIScrollView!
    
    //fields that can bne filled
    @IBOutlet weak var titleField: UITextFieldLayout!
    @IBOutlet weak var releaseDateField: UITextFieldLayout!
    @IBOutlet weak var categoryField: UITextFieldLayout!
    @IBOutlet weak var authorField: UITextFieldLayout!
    
    //task table object
    @IBOutlet weak var taskTable: UITaskTableView!
    
    @IBOutlet weak var profileFrame: UIFlowImageView!
    
    @IBOutlet weak var descriptionAreaEdit: UITextViewLayout!
    
    @IBOutlet weak var formContentView: UIView!
    
    @IBOutlet weak var starRatingEdit: CosmosView!
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var browseImageButton: UIButton!
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    private var taskTableDelegate : UITaskTableDelegate?
    
    var errorAlert : UIAlertController!
    var successAlert : UIAlertController!
    var imageChooseAction = UIAlertController(title:"Choose Image", message: nil, preferredStyle: .actionSheet)
    
    var tasks : [Task]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.flow.image = ""
        
        self.errorAlert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        self.errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.successAlert = UIAlertController(title: "Sucess", message: nil, preferredStyle: .alert)
        self.successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.formContentView.backgroundColor = GenericSettings.backgroundColor
        self.taskTableDelegate = UITaskTableDelegate(pageView: self, tasks: [], tableView: self.taskTable)
        
        self.dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.descriptionAreaEdit.text = ""
        self.descriptionAreaEdit.layer.cornerRadius = GenericSettings.genericCornerRadius
        
        self.taskTable.tableFooterView = UIView(frame: .zero)
        self.taskTable.setupEmptyBackgroundView()
        
        let date = Date()
        self.releaseDateField.text = dateFormatter.string(from: date)
        self.categoryField.text = GenericSettings.categories[0]?.first?.key
        
        self.starRatingEdit.backgroundColor = GenericSettings.backgroundColor
        self.starRatingEdit.filledColor = GenericSettings.themeColor
        self.starRatingEdit.settings.updateOnTouch = true
        self.starRatingEdit.rating = 5
        self.starRatingEdit.starSize = 32
        self.starRatingEdit.settings.fillMode = .full
        self.starRatingEdit.settings.starMargin = 10
        
        do{
            self.dbController = try DBController()
        }
        
        catch let error{
            print("\(error)")
        }
        
        if (self.flow.id != nil){
            self.titleField?.text = self.flow.title
            self.categoryField?.text = self.flow.category
            self.authorField?.text = self.flow.author
            self.releaseDateField?.text = self.flow.releaseDate
            self.starRatingEdit.rating = Double(self.flow.rating)
            self.descriptionAreaEdit?.text = self.flow.description
            
            self.profileFrame.imageView?.image = self.flow.uiImage
            self.profileFrame.updateBackground()
            
            do{
                self.taskTableDelegate!.tasks = try self.dbController.taskDAO.select(flowID: self.flow.id)
            }
            
            catch{
                print("could not retrieve tasks: ", error)
            }
        }
        
        self.taskTable.delegate = self.taskTableDelegate
        self.taskTable.dataSource = self.taskTableDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func releaseDateEditing(_ sender: UITextField) {
        let datePickerView : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date

        guard let date = self.dateFormatter.date(from: (self.releaseDateField?.text)!) else {
            fatalError()
        }
        
        datePickerView.date = date
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    @IBAction func categoryEditing(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let index = GenericSettings.categories.filter {$0.value.keys.contains(self.categoryField.text!)}.first?.key
        pickerView.selectRow(index!, inComponent: 0, animated: false)
        
        sender.inputView = pickerView
    }
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        ImagerPickerManager(sender).pickImage(self){
            image in
            
            autoreleasepool{ () -> () in
                self.profileFrame.imageView?.image = image
                self.profileFrame.updateBackground()
            }
        }
    }
    
    @IBAction func addTaskAction(_ sender: UIButton) {
        self.taskTableDelegate?.addTask()
    }
    
    @IBAction func saveFlowAction(_ sender: Any) {
        self.flow.title = self.titleField.text
        self.flow.category = self.categoryField.text
        self.flow.author = self.authorField.text
        self.flow.releaseDate = self.releaseDateField.text
        self.flow.description = self.descriptionAreaEdit.text
        self.flow.rating = Int(self.starRatingEdit.rating)
        
        let tasks : [Task] = self.taskTableDelegate!.tasks
        
        let documentFolder : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imgFolderPath : URL = documentFolder.appendingPathComponent("DCIM", isDirectory: true)
        var imageName : String?
        var oldImage : String?
        var imagePath : URL?
        
        print(self.flow.category)
        
        //if a category is not assigned
        guard GenericSettings.categories.enumerated().first(where: {$0.element.value.first?.key == self.flow.category}) != nil else {
            self.errorAlert.message = (self.flow.category != "" ? self.flow.category : "<CATEGORY_NOT_INITIALIZED>")  + " is not a valid category"
            present(self.errorAlert, animated: true, completion: nil)
            return
        }

        if (self.profileFrame.imageView?.image != nil) {
            do {
                var isDir : ObjCBool = true
                if (!FileManager.default.fileExists(atPath: imgFolderPath.path, isDirectory: &isDir)){
                    try FileManager.default.createDirectory(atPath: imgFolderPath.path, withIntermediateDirectories: true, attributes: nil)
                }
                //generate name for the profile image
                let letters = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                imageName = String((0...20).map{_ in letters.randomElement()!}) + ".jpg"
                imagePath = imgFolderPath.appendingPathComponent(imageName!, isDirectory: false)
                oldImage = self.flow?.image
                self.flow.image = imageName
            }
                
            catch let error {
                self.errorAlert.message = "Unable to create directory\n\(error)"
                present(self.errorAlert, animated: true, completion: nil)
            }
        }
        
        //saving the flow the database
        do {
            if (self.flow.id == nil){
                try self.dbController.addFlow(flow: self.flow, tasks: tasks)
            }
            
            else{
                try self.dbController.flowDAO.update(flow: self.flow)
                
                for task in tasks{
                    if (task.id != nil){
                        try self.dbController.taskDAO.update(task.id, description: task.description, isDone: task.isDone)
                    }
                    
                    else{
                        task.flowID = self.flow.id
                        try self.dbController.taskDAO.insert(task: task)
                    }
                }
            }
        }
        
        catch let Result.error(message, code, _) where code == SQLITE_CONSTRAINT {
            if (message.contains("UNIQUE")) {  self.errorAlert.message = self.flow.title + " already exists" }
            present(self.errorAlert, animated: true, completion: nil)
        }
        
        catch let error {
            self.errorAlert.message = "\(error)"
            present(self.errorAlert, animated: true, completion: nil)
        }
        
        //Saving the image to the directory of application if exists
        if (self.profileFrame.imageView?.image != nil) {
            let image = GenericSettings.resizeImage(image: self.profileFrame.imageView.image, targetSize: CGSize(width: 300, height: 300))
            if let jpg = GenericSettings.fixOrientation(img: image!)!.jpegData(compressionQuality: 1.0) {
                do {
                    try jpg.write(to: imagePath!)
                    
                    if (oldImage != nil && oldImage != ""){
                        let oldImagePath : URL = imgFolderPath.appendingPathComponent(oldImage!, isDirectory: false)
                        
                        do{
                            try FileManager.default.removeItem(at: oldImagePath)
                        }
                        
                        catch{
                            print("Could not remove old image")
                        }
                    }
                }
                    
                catch let error{
                    self.errorAlert.message = "Could not save profile image to app folder\n\(error)"
                    present(self.errorAlert, animated: true, completion: nil)
                }
            }
                
            else {
                self.errorAlert.message = "could not extract UIImage to PNG data"
                present(self.errorAlert, animated: true, completion: nil)
            }
        }
        
        if (self.flow.id != nil){
            update(target: nil)
            self.navigationController?.popViewController(animated: true)
        }
            
        else{
            self.resetForm()
            self.successAlert.message =  self.flow.title + " has been saved"
            self.present(self.successAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelFormAction(_ sender: Any) {
        let cancelAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel?", preferredStyle: .alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            
            if (self.flow.id != nil){
                self.navigationController?.popViewController(animated: true)
            }
            
            else{
                self.resetForm()
                self.successAlert.message =  "flow has been cancelled"
                self.present(self.successAlert, animated: true, completion: nil)
            }
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(cancelAlert, animated: true, completion: nil)
    }
    
    @objc func datePickerValueChanged(sender : UIDatePicker){
        releaseDateField.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GenericSettings.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return GenericSettings.categories[row]?.first?.key
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryField.text = GenericSettings.categories[row]?.first?.key
    }
    
    func gotToPreviousPage(){
        if (self.flow.id != nil){
            print("the warudo")
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func animateViewMoving(up : Bool, moveValue : CGFloat){
        let movementDuration : TimeInterval = 0.3
        var movement : CGFloat!
        if (up) { movement = -moveValue} else { movement = moveValue }
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    func resetForm() {
        let date = Date()
        
        self.releaseDateField.text = dateFormatter.string(from: date)
        self.titleField.text = nil
        self.categoryField.text = GenericSettings.categories[0]?.first?.key
        self.authorField.text = nil
        self.descriptionAreaEdit.text = nil
        self.starRatingEdit.rating = 5
        self.resetTaskTableView()
        self.profileFrame.imageView?.image = nil
        self.profileFrame.updateBackground()
    }
    
    func resetTaskTableView() {
        self.taskTableDelegate?.tasks.removeAll()
        taskTable.reloadData()
    }
    
    @objc func keyboardWillShow(notification : NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame : CGRect = ((userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue)!
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset : UIEdgeInsets = self.scrollFieldForm.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollFieldForm.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification : NSNotification){
        let contentInset : UIEdgeInsets = UIEdgeInsets.zero
        self.scrollFieldForm.contentInset = contentInset
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
