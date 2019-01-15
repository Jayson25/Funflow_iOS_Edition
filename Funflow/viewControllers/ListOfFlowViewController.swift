//
//  ListOfFlowViewController.swift
//  Funflow
//
//  Created by Jayson Galante on 08/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

class ListOfFlowViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, GenericObserver {

    private let identifier = "flowCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var flowsTable: UITableView!
    
    private var dbController : DBController!
    
    var category : String!
    var flows : [Flow] = []
    var filteredFlows : [Flow] = []
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flowsTable.backgroundView = FieldBackgroundView(image: UIImage(named: "tasks")!.withRenderingMode(.alwaysTemplate), top: "No flow found", bottom: "Please add a flow to start the fun")
        self.flowsTable.delegate = self
        self.flowsTable.dataSource = self
        self.flowsTable.separatorStyle = .none
        self.flowsTable.backgroundColor = GenericSettings.backgroundColor
        
        self.searchBar.delegate = self
        self.searchBar.returnKeyType = UIReturnKeyType.done
        
        do{
            self.dbController = try DBController()
            self.flows = try dbController.flowDAO.selectByCategory(category)
        }
            
        catch let error {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearching){
            self.flowsTable.backgroundView?.isHidden = (self.filteredFlows.count == 0) ? false : true
            return self.filteredFlows.count
        }
 
        self.flowsTable.backgroundView?.isHidden = (self.flows.count == 0) ? false : true
        return self.flows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? FlowCell {
            
            cell.flow = isSearching ? filteredFlows[indexPath.row] : flows[indexPath.row]
            return cell
        }
        
        else{
            return UITableViewCell()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearch()
    }
    
    func updateSearch(){
        if self.searchBar.text == nil || self.searchBar.text == "" {
            self.isSearching = false
            
            view.endEditing(true)
            
            self.flowsTable.reloadData()
        }
            
        else {
            self.isSearching = true
            
            let search = "\(self.searchBar.text!)"
            self.filteredFlows = flows.filter({$0.title.contains(search)})
            
            self.flowsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let flow = storyboard?.instantiateViewController(withIdentifier: "flowView") as! FlowViewController
        flow.flow = self.flows[indexPath.row]
        flow.addObserver(observer: self)
        
        navigationController?.pushViewController(flow, animated: true)
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    func notify(target: Any?) {
        
        do{
            self.flows = try dbController.flowDAO.selectByCategory(category)
            updateSearch()
        }
            
        catch let error {
            print(error)
        }
    }
}
