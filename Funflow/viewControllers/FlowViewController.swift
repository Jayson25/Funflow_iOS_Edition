//
//  FlowViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 13/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

class FlowViewController: UIViewController {
    
    var flow : Flow!
    var tasks : [Task]! = []
    
    private var dbController : DBController!
    private var taskTableDelegate : UITaskTableDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var caegoryLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var progressView: UICircularProgressBar!
    @IBOutlet weak var generalInfoView: UIView!
    @IBOutlet weak var taskTable: UITaskTableView!
    @IBOutlet weak var flowImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            self.dbController = try DBController()
            self.tasks = try dbController.taskDAO.select(flowID: self.flow.id)
        }
        
        catch {
            print(error)
        }
        
        self.view.backgroundColor = GenericSettings.backgroundColor
        
        self.taskTableDelegate = UITaskTableDelegate(self, self.tasks)
        
        GenericSettings.applyLayout(forView: self.generalInfoView)
        
        self.descriptionView.isEditable = false
        GenericSettings.applyLayout(forView: self.descriptionView)
        
        GenericSettings.applyLayout(forView: self.taskTable)
        
        self.ratingView.updateOnTouch = false
        self.ratingView.filledColor = GenericSettings.themeColor
        self.ratingView.emptyBorderColor = GenericSettings.themeColor
        self.ratingView.filledBorderColor = GenericSettings.themeColor
        self.ratingView.backgroundColor = .clear
        
        self.progressView.backgroundColor = .clear
        self.progressView.progress = self.flow.progress
        self.progressView.transform = self.progressView.transform.rotated(by: CGFloat.pi / -2)
        
        self.titleLabel.textColor = GenericSettings.themeColor
        
        GenericSettings.applyLayout(forView: self.flowImage)
        self.flowImage.backgroundColor = (self.flow.uiImage != nil) ? UIColor(patternImage: self.flow.uiImage!) : .gray
        
        self.taskTable.delegate = self.taskTableDelegate
        self.taskTable.dataSource = self.taskTableDelegate
        /*self.taskTable.tableFooterView = UIView(frame: .zero)
        self.taskTable.setupEmptyBackgroundView()*/

        // Do any additional setup after loading the view.
        self.titleLabel?.text = self.flow.title
        self.descriptionView?.text = self.flow.description
        self.caegoryLabel?.text = self.flow.category
        self.authorLabel?.text = self.flow.author
        self.releaseDateLabel?.text = self.flow.releaseDate
        self.ratingView.rating = Double(self.flow.rating)
        self.flowImage?.image = self.flow.uiImage
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
    }*/
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func updateProgress() {
        let total : Float = Float(self.tasks.count)
        let completed : Float = Float(self.tasks.filter({$0.isDone == true}).count)
        
        self.progressView.progress = completed / total
    }
    
    @objc func keyboardWillShow(notification : NSNotification){
        
        var userInfo = notification.userInfo!
        var keyboardFrame : CGRect = ((userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue)!
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
       /* var contentInset : UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset*/
    }
    
    @objc func keyboardWillHide(notification : NSNotification){
        let contentInset : UIEdgeInsets = UIEdgeInsets.zero
        //self.scrollView.contentInset = contentInset
    }
}
