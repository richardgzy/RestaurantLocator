//
//  restaurantTableViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData

class restaurantTableViewController: UITableViewController, AddRestaurantDelegate {
    var allRestaurants: [NSManagedObject] = []
    var currentCategory: Category?
    var managedObjectContext: NSManagedObjectContext
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantListSegue"
        {
            let controller: CategoryTableViewController = segue.destination as! CategoryTableViewController
            controller.delegate = self
        }
    }
    
    func addRestaurant(restaurant: Restaurant) {
        self.currentCategory?.addRestaurant(value: restaurant)
        self.allRestaurants = currentCategory?.containRestaurant?.allObjects as! [Restaurant]
        self.tableView.reloadData()
        do
        {
            try self.managedObjectContext.save()
        }
        catch
        {
            print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch (section){
        case 0: return self.allRestaurants.count
        case 1: return 1
        default:
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
            
            // Configure the cell...
            let s = self.allRestaurants[indexPath.row] as! Restaurant
            //        cell.nameLabel.text = s.name
            //        cell.abilitylabel.text = s.ability
            
            cell.restaurantNameLabel.text = s.name!
            var df: DateFormatter = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            cell.restaurantDateLabel.text = df.string(from: s.addDate! as! Date)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTotalCell", for: indexPath)
            cell.textLabel?.text = "Total Restaurant: \(self.allRestaurants.count)"
            return cell
        }
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

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
