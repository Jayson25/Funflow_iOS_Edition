//
//  AddCardViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 06/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit
import SQLite

class FlowFormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {

    fileprivate var imagePath : String!
    let dateFormatter: DateFormatter = DateFormatter()
    
    var dbController : DBController!
    
    //labels for form
    @IBOutlet weak var titleFieldLabel: FieldLabel!
    @IBOutlet weak var categoryFieldLabel: FieldLabel!
    @IBOutlet weak var authorFieldLabel: FieldLabel!
    @IBOutlet weak var releaseDateFieldLabel: FieldLabel!
    @IBOutlet weak var descriptionFieldLabel: FieldLabel!
    @IBOutlet weak var RatingEditLabel: FieldLabel!
    
    //scroll view
    @IBOutlet weak var scrollFieldForm: UIScrollView!
    
    //fields that can bne filled
    @IBOutlet weak var titleField: TextFieldLayout!
    @IBOutlet weak var releaseDateField: TextFieldLayout!
    @IBOutlet weak var categoryField: TextFieldLayout!
    @IBOutlet weak var authorField: TextFieldLayout!
    
    //task table object
    @IBOutlet weak var taskTable: TaskTableView!
    
    @IBOutlet weak var profileFlowImage: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBOutlet weak var descriptionAreaEdit: UITextView!
    
    @IBOutlet weak var formContentView: UIView!
    
    @IBOutlet weak var starRatingEdit: CosmosView!
    
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var browseImageButton: UIButton!
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    private var taskTableDelegate : TaskTableDelegate?
    
    var errorAlert : UIAlertController!
    var successAlert : UIAlertController!
    var imageChooseAction = UIAlertController(title:"Choose Image", message: nil, preferredStyle: .actionSheet)
    
    var tasks : [Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorAlert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        self.errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.successAlert = UIAlertController(title: "Sucess", message: nil, preferredStyle: .alert)
        self.successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        cardImageView.backgroundColor = UIColor.white
        cardImageView.layer.cornerRadius = GenericSettings.genericCornerRadius
        
        tasks = [Task]()
        
        self.formContentView.backgroundColor = GenericSettings.backgroundColor
        self.taskTableDelegate = TaskTableDelegate(self, self.tasks ?? [])
        
        self.dateFormatter.dateStyle = DateFormatter.Style.medium
        self.dateFormatter.timeStyle = DateFormatter.Style.none
        
        self.releaseDateField.delegate = self
        self.categoryField.delegate = self
        self.authorField.delegate = self
        
        self.descriptionAreaEdit.text = ""
        self.descriptionAreaEdit.layer.cornerRadius = GenericSettings.genericCornerRadius
        self.descriptionAreaEdit.delegate = self
        
        self.taskTable.delegate = self.taskTableDelegate
        self.taskTable.dataSource = self.taskTableDelegate
        self.taskTable.tableFooterView = UIView(frame: CGRect.zero)
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
            print("hello my world: \(error)")
        }
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
    
    override func willMove(toParent parent: UIViewController?) {
        print("hello")
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("no more")
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
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        ImagerPickerManager(sender).pickImage(self){
            image in

            self.profileFlowImage.image = image
        }
    }
    
    @IBAction func addTaskAction(_ sender: UIButton) {
        taskTable.beginUpdates()
        self.taskTableDelegate!.tasks.append(Task())
        let indexPath = IndexPath(row: self.taskTableDelegate!.tasks.count-1, section: 0)
        taskTable.insertRows(at: [indexPath], with: .automatic)
        taskTable.endUpdates()
    }
    
    @IBAction func saveFlowAction(_ sender: Any) { 
        let title : String = self.titleField.text!
        let category : String = self.categoryField.text!
        let author : String = self.authorField.text!
        let releaseDate : String = self.releaseDateField.text!
        let description : String = self.descriptionAreaEdit.text!
        let rating : Int = Int(self.starRatingEdit.rating)
        
        guard let isValidCatgory = GenericSettings.categories.enumerated().first(where: {$0.element.value.first?.key == category}) else {
            self.errorAlert.message = category != "" ? category : "<CATEGORY_NOT_INITIALIZED>"  + " is not a valid category"
            present(self.errorAlert, animated: true, completion: nil)
            return
        }
        
        let flow : Flow = Flow(title: title, image: "", category: category, author: author, releaseDate: releaseDate, rating: rating, description: description)
        let tasks : [Task] = self.taskTableDelegate!.tasks
        
        /**save Image to folder app system
        */
        
        let documentFolder : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imgFolderPath : URL = documentFolder.appendingPathComponent("DCIM", isDirectory: true)
        
        if (self.profileFlowImage.image != nil){
            //create folders if not exists
            do{
                
                var isDir : ObjCBool = true
                if (!FileManager.default.fileExists(atPath: imgFolderPath.path, isDirectory: &isDir)){
                    try FileManager.default.createDirectory(atPath: imgFolderPath.path, withIntermediateDirectories: true, attributes: nil)
                }
                
                //generate name for the profile image
                let letters = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let imageName = String((0...20).map{_ in letters.randomElement()!}) + ".png"
                let imgPath : URL = imgFolderPath.appendingPathComponent(imageName, isDirectory: false)
                
                //save image to file
                if let png = GenericSettings.fixOrientation(img: self.profileFlowImage.image!).pngData(){
                    do {
                        try png.write(to: imgPath)
                        flow.image = imageName
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
            
            catch let error{
                self.errorAlert.message = "Unable to create directory\n\(error)"
                present(self.errorAlert, animated: true, completion: nil)
            }
        }
        
        do{
            try self.dbController.addFlow(flow: flow, tasks: tasks)
            self.resetForm()
        }
        
        catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT{
            if (message.contains("UNIQUE")){
                self.errorAlert.message = flow.title + " already exists"
            }
            
            present(self.errorAlert, animated: true, completion: nil)
        }
        
        catch let error{
            self.errorAlert.message = "\(error)"
            present(self.errorAlert, animated: true, completion: nil)
        }
        
        defer{
            self.successAlert.message = flow.title + " has been saved"
            present(self.successAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelFormAction(_ sender: Any) {
        let cancelAlert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel?", preferredStyle: .alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.resetForm()
            self.successAlert.message =  "flow has been cancelled"
            self.present(self.successAlert, animated: true, completion: nil)
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
        self.titleField.text = ""
        self.categoryField.text = GenericSettings.categories[0]?.first?.key
        self.authorField.text = ""
        self.descriptionAreaEdit.text = ""
        self.starRatingEdit.rating = 0
        self.profileFlowImage.image = nil
        self.resetTaskTableView()
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
