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

class CategoryTableViewController: UIViewController, AddCategoryDelegate, UpdateCategoryDelegate,  UITableViewDelegate, UITableViewDataSource{

    var categoryList: [Category] = []
    var selectedCategory: Category?
    var restaurantList: [NSManagedObject] = []
    var managedObjectContext : NSManagedObjectContext
    
    @IBAction func addNewCategoryButton(_ sender: Any) {
        performSegue(withIdentifier: "addNewCategorySegue", sender: "Add Category Button")
    }
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    //set up the tableview edit button
    @IBAction func categoryEditButton(_ sender: UIBarButtonItem) {
        if self.categoryTableView.isEditing {
            self.categoryTableView.isEditing = false
            self.categoryTableView.setEditing(false, animated: false)
            sender.style = UIBarButtonItemStyle.plain
            sender.title = "Edit"
            self.categoryTableView.reloadData()
        } else {
            self.categoryTableView.isEditing = true
            self.categoryTableView.setEditing(true, animated: true)
            sender.title = "Done"
            sender.style =  UIBarButtonItemStyle.done
            self.categoryTableView.reloadData()
        }
    }
    @IBAction func sortByNameButton(_ sender: Any) {
        var nameArray: [String] = []
        var sortedArray: [NSManagedObject] = []
        
        for category in categoryList{
            nameArray.append(category.name!)
        }

        nameArray.sort()
        for item in nameArray{
            for category in categoryList{
                if category.name == item{
                    sortedArray.append(category)
                }
            }
        }
        categoryList = sortedArray as! [Category]
        categoryTableView.reloadData()
    }
    
    @IBAction func sortByCountButton(_ sender: Any) {
        var countArray: [Int] = []
        var sortedArray: [NSManagedObject] = []
        
        for category in categoryList {
            countArray.append(category.containRestaurant!.count)
        }
        
        //remove duplicate
        countArray = Array(Set(countArray))
        
        for item in countArray{
            for category in categoryList {
                if category.containRestaurant!.count == item{
                    sortedArray.append(category)
                }
            }
        }
        categoryList = sortedArray as! [Category]
        categoryTableView.reloadData()
    }
    
    //define what to do when user rearrange the table cells
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let item : Category = categoryList[sourceIndexPath.row] ;
        categoryList.remove(at: sourceIndexPath.row);
        categoryList.insert(item, at: destinationIndexPath.row)
        self.saveAllChanges()
        self.categoryTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        populateCategoryAndRestaurantDataIntoCoreData(id: 1, name: "Chinese Food", color: "Red", imageFilename: "chinese_food.jpg")
        populateCategoryAndRestaurantDataIntoCoreData(id: 2, name: "Australian Food", color: "Yellow", imageFilename: "australia_food.jpg")
        populateCategoryAndRestaurantDataIntoCoreData(id: 3, name: "Japanese Food", color: "Blue", imageFilename: "japanese_food.jpg")
        
        saveAllChanges()
        
        let myAlert = UIAlertController(title: "Sample Data Added", message: "You don't have any category in your application, we add some sample data for you, please restart the app to have a look, enjoy!", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    // call this function will add a category record to core data
    func populateCategoryAndRestaurantDataIntoCoreData(id: Int64, name: String, color: String, imageFilename: String){
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedObjectContext) as? Category
        category!.id = id
        category!.name = name
        category!.color = color
        let image = UIImage(named: imageFilename)
        category!.icon = UIImagePNGRepresentation(image!) as NSData?
        
        //populate restaurants
        switch name{
            case "Chinese Food":
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "chinese_food.jpg")!, id: 1, name: "New Shanghai", rating: 5, date: NSDate(), address: "323/287 Lonsdale St, Melbourne VIC 3000, Australia", notificationRadius: 0)
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "chinese_food.jpg")!, id: 2, name: "Spice Temple", rating: 4, date: NSDate(), address: "8 Whiteman St, Southbank VIC 3006, Australia", notificationRadius: 250)
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "chinese_food.jpg")!, id: 3, name: "Secret Kitchen (CBD Chinatown)", rating: 2, date: NSDate(), address: "222 Exhibition St, Melbourne VIC 3000, Australia", notificationRadius: 0)
                break
            case "Australian Food":
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "australia_food.jpg")!, id: 1, name: "Aussie Steak 'N' Burger", rating: 3, date: NSDate(), address: "12-16 Newquay Promenade, Docklands VIC 3008, Australia", notificationRadius: 0)
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "australia_food.jpg")!, id: 2, name: "Henry & the Fox", rating: 4, date: NSDate(), address: "525 Little Collins St, Melbourne VIC 3000, Australia", notificationRadius: 1000)
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "australia_food.jpg")!, id: 3, name: "The Mill", rating: 2, date: NSDate(), address: "71 Hardware Ln, Melbourne VIC 3000, Australia", notificationRadius: 0)
                break
            case "Japanese Food":
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "japanese_food.jpg")!, id: 1, name: "Miyako Japanese Cuisine & Teppanyaki", rating: 3, date: NSDate(), address: "UR2/3 Southgate Ave, Southbank VIC 3006, Australia", notificationRadius: 0)
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "japanese_food.jpg")!, id: 2, name: "Hanabishi Japanese Restaurant", rating: 3, date: NSDate(), address: "187 King St, Melbourne VIC 3000, Australia", notificationRadius: 0)
                populateRestaurantDataIntoCoreData(destinationCategory: category!, logo: UIImage(named: "japanese_food.jpg")!, id: 3, name: "DonDon", rating: 5, date: NSDate(), address: "198 Little Lonsdale St, Melbourne VIC 3000, Australia", notificationRadius: 0)
                break
        default: break
        }
    }
    
    func populateRestaurantDataIntoCoreData(destinationCategory: Category, logo: UIImage, id: Int64, name: String, rating: Int16, date: NSDate, address: String, notificationRadius: Int16 ){
        let restaurantToBeAdded = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: managedObjectContext) as? Restaurant
        
        restaurantToBeAdded!.id = id
        restaurantToBeAdded!.name = name
        restaurantToBeAdded!.rating = rating
        restaurantToBeAdded!.addDate = date
        restaurantToBeAdded!.address = address
        restaurantToBeAdded!.notificationRadius = notificationRadius
        restaurantToBeAdded!.belongCategory = destinationCategory
        restaurantToBeAdded!.logo = UIImagePNGRepresentation(logo) as NSData?
        
        if destinationCategory.containRestaurant?.count == 0{
            var tempArray: [Restaurant] = []
            tempArray.append(restaurantToBeAdded!)
            destinationCategory.containRestaurant = NSSet(array: tempArray)
        }else{
            destinationCategory.containRestaurant?.adding(restaurantToBeAdded!)
        }
        
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
            self.categoryList = try self.managedObjectContext.fetch(fetchRequestForCategory as! NSFetchRequest<NSFetchRequestResult>) as! [Category]
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
        
        categoryTableView!.delegate = self
        categoryTableView!.dataSource = self
        
        
        //sort table as the sequence saved
        let path = Bundle.main.path(forResource: "myData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let tableSequence = dict!.object(forKey: "Category") as! [String]
        var sortedArray: [NSManagedObject] = []
        for item in tableSequence{
            for category in categoryList {
                if category.name == item{
                    sortedArray.append(category)
                }
            }
        }
        categoryList = sortedArray as! [Category]
        
    }
    
    //perform segue and direct user to the restaurant detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = self.categoryList[indexPath.row]
        self.performSegue(withIdentifier: "showRestaurantListSegue", sender: "Category Cell Touch")
    }
    
    //set up selectedCategory before editing
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        selectedCategory = self.categoryList[(indexPath.row)]
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
        categoryTableView.reloadData()
    }
    
    func updateCategory(updatedCategory: [Category]){
        categoryList = updatedCategory
        for item in categoryList{
            managedObjectContext.refresh(item as NSManagedObject, mergeChanges: true)
        }
        categoryTableView.reloadData()
    }
    
    // all cells except the total cell are editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
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
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoryList.count
    }
    
    //configure the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            
            let s = self.categoryList[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
}
