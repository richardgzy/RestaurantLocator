//
//  restaurantTableViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData
protocol UpdateCategoryDelegate {
    func updateCategory(updatedCategory: [Category])
}

class restaurantTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var restaurantList: [Restaurant] = []
    var categoryList: [Category] = []
    var currentCategory: Category?
    var selectedRestaurant: Restaurant?
    var managedObjectContext: NSManagedObjectContext
    var delegate: UpdateCategoryDelegate?
    
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBAction func editRestaurantButton(_ sender: UIBarButtonItem) {
        if self.restaurantTableView.isEditing {
            self.restaurantTableView.isEditing = false
            self.restaurantTableView.setEditing(false, animated: false)
            sender.style = UIBarButtonItemStyle.plain
            sender.title = "Edit"
            self.restaurantTableView.reloadData()
        } else {
            self.restaurantTableView.isEditing = true
            self.restaurantTableView.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style =  UIBarButtonItemStyle.done
            self.restaurantTableView.reloadData()
        }
    }
    
    @IBAction func sortByNameButton(_ sender: Any) {
    }
    @IBAction func sortByRating(_ sender: Any) {
    }
    @IBAction func addNewRestaurantButton(_ sender: Any) {
    }
    
    func addRestaurant(restaurant: Restaurant) {
        currentCategory?.addRestaurant(value: restaurant)
        restaurantList = currentCategory?.containRestaurant?.allObjects as! [Restaurant]
        restaurantTableView.reloadData()
        do
        {
            try managedObjectContext.save()
        }
        catch
        {
            print(error)
        }     }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        
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

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurantList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRestaurant = self.restaurantList[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
            
            // Configure the cell...
            let s = self.restaurantList[indexPath.row] 
            cell.restaurantNameLabel.text = s.name!
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            cell.restaurantDateLabel.text = df.string(from: s.addDate! as Date)
            cell.restaurantImageView.image = UIImage(data: (s.logo!) as Data)
            return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let editOption = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.performSegue(withIdentifier: "editRestaurantSegue", sender: "Restaurtant Edit Button")
        }
        editOption.backgroundColor = .orange
        
        let deleteOption = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let toBeDeleted = self.restaurantList[editActionsForRowAt.row]
            self.restaurantList.remove(at: editActionsForRowAt.row)
            self.managedObjectContext.delete(toBeDeleted)
            
            let tempCategory = toBeDeleted.belongCategory!
            for item in self.categoryList{
                if item == tempCategory{
                    
                }
            }
            
            self.delegate?.updateCategory(updatedCategory: self.categoryList)
            
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
    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

}
