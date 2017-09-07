//
//  CategoryTableViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/27.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class CategoryTableViewController: UITableViewController, AddCategoryDelegate{

    @IBAction func addNewCategoryButton(_ sender: Any) {
        performSegue(withIdentifier: "addNewCategorySegue", sender: "Add Category Button")
    }
    var categoryList: [NSManagedObject] = []
    var selectedCategory: Category?
    var restaurantList: [NSManagedObject] = []
    var managedObjectContext : NSManagedObjectContext
    
    //set up the tableview edit button
    @IBAction func categoryEditButton(_ sender: UIBarButtonItem) {
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.tableView.setEditing(false, animated: false)
            sender.style = UIBarButtonItemStyle.plain
            sender.title = "Edit"
            self.tableView.reloadData()
        } else {
            self.tableView.isEditing = true
            self.tableView.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style =  UIBarButtonItemStyle.done
            self.tableView.reloadData()
        }
    }
    
    //define what to do when user rearrange the table cells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item : Category = categoryList[sourceIndexPath.row] as! Category;
        categoryList.remove(at: sourceIndexPath.row);
        categoryList.insert(item, at: destinationIndexPath.row)
        self.saveAllChanges()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            categoryList.remove(at: indexPath.row);
            self.categoryEditButton(editButtonItem);
            tableView.reloadData();
        }
    }
    
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
        
        saveAllChanges()
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
        
        let address = restaurantToBeAdded!.address
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location else{
                    print("Error, can't get the location")
                    return
            }
            restaurantToBeAdded!.latitude = location.coordinate.latitude
            restaurantToBeAdded!.longitude = location.coordinate.longitude
        }
        
    }
    
    //call this function to save all changes in managedObjectContext
    func saveAllChanges(){
        do {
            try self.managedObjectContext.save()
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
            
            //save category list to global context
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.categoryList = categoryList
            
        }catch{
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    //perform segue and direct user to the restaurant detail page
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = self.categoryList[indexPath.row] as? Category
        self.performSegue(withIdentifier: "showRestaurantListSegue", sender: "Category Cell Touch")
    }
    
    //set up selectedCategory before editing
    override func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        selectedCategory = self.categoryList[(indexPath.row)] as? Category
    }
    
    
    //prepare for segue and pass data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? restaurantTableViewController{
            if selectedCategory != nil{
                destinationVC.currentCategory = selectedCategory
                destinationVC.categoryList = categoryList
                destinationVC.managedObjectContext = self.managedObjectContext
            }
        }else if let destinationVC = segue.destination as? AddCategoryViewController{
            if sender as! String == "Add Category Button"{
                destinationVC.currentCategory = nil
                destinationVC.managedObjectContext = self.managedObjectContext
                destinationVC.delegate = self
            }else{
                destinationVC.currentCategory = selectedCategory
                destinationVC.managedObjectContext = self.managedObjectContext
                destinationVC.delegate = self
            }
        }
    }
    
    // implement delegate function
    func addCategory(newCategory: Category) {
        categoryList.append(newCategory)
        self.tableView.reloadData()
    }
    
    // all cells except the total cell are editable
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let editOption = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            self.performSegue(withIdentifier: "addNewCategorySegue", sender: "Category Edit Button")
        }
        editOption.backgroundColor = .orange
        
        let deleteOption = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let toBeDeleted = self.categoryList[editActionsForRowAt.row]
            self.categoryList.remove(at: editActionsForRowAt.row)
            self.managedObjectContext.delete(toBeDeleted)
            self.saveAllChanges()
            
            tableView.reloadData()
        }
        deleteOption.backgroundColor = .red
        
        return [deleteOption, editOption]
    }
    
    // all cells are moveable
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoryList.count
    }
    
    //configure the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
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
                    break
                case "Grey":
                    cell.colorLabel.backgroundColor = UIColor.gray
                    break
                case "Green":
                    cell.colorLabel.backgroundColor = UIColor.green
            default:
                    break
            }
            
            cell.categoryIcon.image = UIImage(data: (s.icon!) as Data)
            
            return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }
    
}
