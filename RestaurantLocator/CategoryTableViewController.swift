//
//  CategoryTableViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/27.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData

protocol AddRestaurantDelegate {
    func addRestaurant(restaurant: Restaurant)
}

class CategoryTableViewController: UITableViewController {
    @IBOutlet weak var mapViewButton: UIBarButtonItem!
    @IBOutlet weak var addNewCategoryButton: UIButton!
    var categoryList: [NSManagedObject] = []
    var delegate: AddRestaurantDelegate?
    var restaurantList: [NSManagedObject] = []
    var managedObjectContext : NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    func addSampleData(){
        let sampleCategoryData = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedObjectContext) as? Category
        sampleCategoryData!.name = "Sample Category"
        sampleCategoryData!.color = "Red"
        //icon setting
        let image = UIImage(named: "chinese_food.jpg")
        sampleCategoryData!.icon = UIImagePNGRepresentation(image!) as! NSData
        
        let sampleRestaurantData = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        
        sampleRestaurantData!.name = "Sample Restaurant"
        sampleRestaurantData!.rating = 1
        sampleRestaurantData!.addDate = NSDate()
        sampleRestaurantData!.address = "Sample address"
        sampleRestaurantData!.notificationRadius = 0
        
        sampleRestaurantData!.belongCategory = sampleCategoryData
        sampleCategoryData!.containRestaurant = NSSet(array: [sampleRestaurantData])
        
        saveRecords()
    }
    
    func saveRecords(){
        do {
            try self.managedObjectContext.save()
            //try to refresh the data?
            do {
                let fetchRequestForCategory = NSFetchRequest<NSManagedObject>(entityName: "Category")
                try self.categoryList = managedObjectContext.fetch(fetchRequestForCategory)
                
                let fetchRequestForRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
                try self.restaurantList = managedObjectContext.fetch(fetchRequestForRestaurant)
            } catch {
                let fetchError = error as NSError
                print(fetchError)
            }
        } catch {
            print("cannot save \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequestForCategory = NSFetchRequest<NSManagedObject>(entityName: "Category")
        let fetchRequestForRestaurant = NSFetchRequest<NSManagedObject>(entityName: "Restaurant")
        
        do{
            self.categoryList = try self.managedObjectContext.fetch(fetchRequestForCategory)
            self.restaurantList = try self.managedObjectContext.fetch(fetchRequestForRestaurant)
            
            //  Implement of initial data needed
            if self.categoryList.count == 0{
                addSampleData()
            }
            
        }catch{
            let fetchError = error as NSError
            print(fetchError)
        }
        
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
        case 0: return self.categoryList.count
        case 1: return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            // Configure the cell...
            let s = self.categoryList[indexPath.row] as! Category
            cell.categoryNameLabel.text = s.name!
            let restaurantNumber = s.containRestaurant!.count
//            if restaurantNumber == nil{
//                cell.restaurantCountLabel.text = "Total Restaurants: 0"
//            }else{
                cell.restaurantCountLabel.text = "Total Restaurants: \(restaurantNumber)"
//            }
            
            if s.color == "Red"{
                cell.backgroundColor = UIColor.red
            }
            
            cell.categoryIcon.image = UIImage(data: (s.icon as! NSData) as! Data)
            
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTotalCell", for: indexPath)
            cell.textLabel?.text = "Total Category: \(self.categoryList.count)"
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
