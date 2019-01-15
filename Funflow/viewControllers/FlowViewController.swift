//
//  FlowViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 13/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

class FlowViewController: Observable, GenericObserver {
    
    var flow : Flow!
    
    private var dbController : DBController!
    private var taskTableDelegate : UITaskTableDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var caegoryLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var editFlowButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var progressView: UICircularProgressBar!
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var taskTable: UITaskTableView!
    @IBOutlet weak var flowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskTableDelegate = UITaskTableDelegate(pageView: self, tasks: [], tableView: self.taskTable)
        self.taskTableDelegate?.progressView = self.progressView
        self.taskTableDelegate?.flowID = self.flow.id
        
        do{
            self.dbController = try DBController()
            self.taskTableDelegate?.tasks = try dbController.taskDAO.select(flowID: self.flow.id)
        }
        
        catch {
            print(error)
        }
        
        self.view.backgroundColor = GenericSettings.backgroundColor

        GenericSettings.applyLayout(forView: self.generalInfoView)
        
        self.descriptionView.isEditable = false
        GenericSettings.applyLayout(forView: self.descriptionView)
        
        GenericSettings.applyLayout(forView: self.taskTable)
        
        self.ratingView.updateOnTouch = false
        self.ratingView.filledColor = GenericSettings.themeColor
        self.ratingView.emptyBorderColor = GenericSettings.themeColor
        self.ratingView.filledBorderColor = GenericSettings.themeColor
        self.ratingView.backgroundColor = .clear
        
        self.flow.updateProgress()
        self.progressView.backgroundColor = .clear
        self.progressView.progress = self.flow.progress
        self.progressView.transform = self.progressView.transform.rotated(by: CGFloat.pi / -2)
        
        self.titleLabel.textColor = GenericSettings.themeColor
        
        GenericSettings.applyLayout(forView: self.flowImage)
        
        
        self.taskTable.delegate = self.taskTableDelegate
        self.taskTable.dataSource = self.taskTableDelegate
        self.taskTable.tableFooterView = UIView(frame: .zero)
        self.taskTable.setupEmptyBackgroundView()
        
        GenericSettings.applyLayout(forView: self.editFlowButton)
        self.editFlowButton.addTarget(self, action: #selector(editFlow), for: .touchUpInside)

        fillFields()
        
        for obs in self.observers{
            self.taskTableDelegate?.addObserver(observer: obs)
        }
    }
    
    func fillFields(){
        // Do any additional setup after loading the view.
        self.titleLabel?.text = self.flow.title
        self.descriptionView?.text = self.flow.description
        self.caegoryLabel?.text = self.flow.category
        self.authorLabel?.text = self.flow.author
        self.releaseDateLabel?.text = self.flow.releaseDate
        self.ratingView.rating = Double(self.flow.rating)
        self.flowImage?.image = self.flow.uiImage
        self.flowImage.backgroundColor = (self.flow.uiImage != nil) ? UIColor(patternImage: self.flow.uiImage!) : .gray
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
    
    @objc func keyboardWillShow(notification : NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame : CGRect = ((userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue)!
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset : UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification : NSNotification){
        let contentInset : UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
    }
    
    @IBAction func addTaskAction(_ sender: Any) {
        self.taskTableDelegate?.addTask()
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Deletion Waring", message: "Are you sure you want to remove this flow?", preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) {
            (action) in
            
            do{
               try self.dbController.flowDAO.delete(id: self.flow.id)
               let successAlert = UIAlertController(title: "Succes", message: "Flow has been successfully deleted", preferredStyle: .alert)
               let ok = UIAlertAction(title: "OK", style: .default) {
                    (action) in
                    self.update(target: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                
                successAlert.addAction(ok)
                self.present(successAlert, animated: true, completion: nil)
            }
            
            catch{
                let errorAlert = UIAlertController(title: "Error", message: "Deletion failed", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        deleteAlert.addAction(yes)
        deleteAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(deleteAlert, animated: true, completion: nil)
        
    }
    
    @objc func editFlow(){
        let editPage = storyboard?.instantiateViewController(withIdentifier: "FlowFormView") as! FlowFormViewController
        editPage.flow = self.flow
        editPage.addObserver(observer: self)
        
        navigationController?.pushViewController(editPage, animated: true)
    }
    
    func notify(target: Any?) {
        fillFields()
        
        print("is refreshing table")
        
        do{
            self.taskTableDelegate?.tasks = try dbController.taskDAO.select(flowID: self.flow.id)
            self.taskTable.reloadData()
            print("done refreshing task table")
        }
        
        catch{
            print(error)
        }
        
        update(target: nil)
    }
}
