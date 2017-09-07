//
//  restaurantTableViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData

class restaurantTableViewController: UITableViewController {
    var restaurantList: [NSManagedObject] = []
    var categoryList: [NSManagedObject] = []
    var currentCategory: Category?
    var selectedRestaurant: Restaurant?
    var managedObjectContext: NSManagedObjectContext
    
    func addRestaurant(restaurant: Restaurant) {
        self.currentCategory?.addRestaurant(value: restaurant)
        self.restaurantList = currentCategory?.containRestaurant?.allObjects as! [Restaurant]
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
        if currentCategory != nil{
            restaurantList = currentCategory?.containRestaurant?.allObjects as! [Restaurant]
        }
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurantList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = self.restaurantList[indexPath.row] as? Restaurant
        self.performSegue(withIdentifier: "showRestaurantDetailSegue", sender: (Any).self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetailSegue"
        {
            let controller: RestaurantDetailViewController = segue.destination as! RestaurantDetailViewController
            controller.currentRestaurant = selectedRestaurant
        } else if segue.identifier == "editRestaurantSegue"{
            let controller: AddNewRestaurantViewController = segue.destination as! AddNewRestaurantViewController
            controller.currentRestaurant = selectedRestaurant
            controller.categoryList = categoryList as? NSMutableArray
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
            
            // Configure the cell...
            let s = self.restaurantList[indexPath.row] as! Restaurant
            cell.restaurantNameLabel.text = s.name!
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            cell.restaurantDateLabel.text = df.string(from: s.addDate! as Date)
            cell.restaurantImageView.image = UIImage(data: (s.logo!) as Data)
            return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let editOption = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.performSegue(withIdentifier: "editRestaurantSegue", sender: "Restaurtant Edit Button")
        }
        editOption.backgroundColor = .orange
        
        let deleteOption = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let toBeDeleted = self.restaurantList[editActionsForRowAt.row]
            self.restaurantList.remove(at: editActionsForRowAt.row)
            self.managedObjectContext.delete(toBeDeleted)
            self.saveAllChanges()
            
            tableView.reloadData()
        }
        deleteOption.backgroundColor = .red
        
        return [deleteOption, editOption]
    }

    //call this function to save all changes in managedObjectContext
    func saveAllChanges(){
        do {
            try self.managedObjectContext.save()
        } catch {
            print("cannot save \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
