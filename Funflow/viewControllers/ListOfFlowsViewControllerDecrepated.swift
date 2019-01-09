//
//  ListOfCards.swift
//  Funflow
//
//  Created by Jayson Galante on 11/12/2018.
//  Copyright © 2018 utt. All rights reserved.
//

import UIKit

class ListOfFlowsViewControllerDecrepated: UITableViewController {
    
    private let identifier = "flowRow"
    var category : String!
    private var flows : [Flow]!
    private var dbController : DBController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        let emptyBGV = FieldBackgroundView(image: UIImage(named: "music")!.withRenderingMode(.alwaysTemplate), top: "hello", bottom: "nope")
        self.tableView.backgroundView = emptyBGV
        
        do{
            self.dbController = try DBController()
            self.flows = try dbController.flowDAO.selectByCategory(category)
            print (flows.count)
        }
        
        catch let error {
            print(error)
            self.flows = [Flow]()
        }

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return flows.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (flows.count == 0){
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = false
        }
            
        else {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundView?.isHidden = true
        }
        
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return GenericSettings.rowSpacing
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FlowCell
        // Configure the cell...

        do{
            let image : String = self.flows[indexPath.section].image
                
            let folderPath : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL : URL = folderPath.appendingPathComponent("DCIM").appendingPathComponent(image)
            let imageData = try Data(contentsOf: imageURL)
            
            cell.logoCard?.image = UIImage(data: imageData)!
        }
        
        catch{
            print("error", error)
            cell.logoCard.image = UIImage(named: "movie")
        }
        
        cell.labelView.text = self.flows[indexPath.section].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
