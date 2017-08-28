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
    var selectedCategory: Category?
    var delegate: AddRestaurantDelegate?
    var restaurantList: [NSManagedObject] = []
    var managedObjectContext : NSManagedObjectContext
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    //add sample data if the core data is empty
    func addSampleData(){
        //populate category data
        populateCategoryAndRestaurantDataIntoCoreData(name: "Chinese Food", color: "Red", imageFilename: "chinese_food.jpg")
        populateCategoryAndRestaurantDataIntoCoreData(name: "Australian Food", color: "Yellow", imageFilename: "australia_food.jpg")
        populateCategoryAndRestaurantDataIntoCoreData(name: "Japanese Food", color: "Blue", imageFilename: "japanese_food.jpg")
        
        saveRecords()
    }
    
    // call this function will add a category record to core data
    func populateCategoryAndRestaurantDataIntoCoreData(name: String, color: String, imageFilename: String){
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedObjectContext) as? Category
        category!.name = name
        category!.color = color
        let image = UIImage(named: imageFilename)
        category!.icon = UIImagePNGRepresentation(image!) as NSData?
        
        //populate restaurants
        switch name{
            case "Chinese Food":
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "chinese_food.jpg")!, name: "New Shanghai", rating: 5, date: NSDate(), address: "323/287 Lonsdale St, Melbourne VIC 3000, Australia", notificationRadius: 0)
                break
            case "Australian Food":
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "australia_food.jpg")!, name: "Aussie Steak 'N' Burger", rating: 4, date: NSDate(), address: "12-16 Newquay Promenade, Docklands VIC 3008, Australia", notificationRadius: 0)
                break
            case "Japanese Food":
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "japanese_food.jpg")!, name: "Sushi Sushi", rating: 3, date: NSDate(), address: "B-141/1341 Dandenong Rd, Chadstone VIC 3148, Australia", notificationRadius: 0)
                break
        default: break
        }
    }
    
    func populateRestaurantDataIntoCoreData(destinationCategory: Category, logo: UIImage, name: String, rating: Int16, date: NSDate, address: String, notificationRadius: Int16 ){
        let restaurantToBeAdded = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        
        restaurantToBeAdded!.name = name
        restaurantToBeAdded!.rating = rating
        restaurantToBeAdded!.addDate = date
        restaurantToBeAdded!.address = address
        restaurantToBeAdded!.notificationRadius = notificationRadius
        restaurantToBeAdded!.belongCategory = destinationCategory
        restaurantToBeAdded!.logo = UIImagePNGRepresentation(logo) as NSData?
        var tempArray: [Restaurant] = []
        tempArray.append(restaurantToBeAdded!)
        destinationCategory.containRestaurant = NSSet(array: tempArray)
    }
    
    //call this function will add a
    
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
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = self.categoryList[indexPath.row] as? Category
        self.performSegue(withIdentifier: "showRestaurantListSegue", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? restaurantTableViewController{
            if selectedCategory != nil{
                destinationVC.currentCategory = selectedCategory
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
            
            switch s.color!{
                case "Red":
                    cell.colorLabel.backgroundColor = UIColor.red
                    break
                case "Yellow":
                    cell.colorLabel.backgroundColor = UIColor.yellow
                    break
                case "Blue":
                    cell.colorLabel.backgroundColor = UIColor.blue
            default:
                    break
            }
            
            cell.categoryIcon.image = UIImage(data: (s.icon!) as Data)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTotalCell", for: indexPath)
            cell.textLabel?.text = "Total Category: \(self.categoryList.count)"
            return cell
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }
    
}
