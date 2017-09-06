//
//  AddCategoryViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/31.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData

protocol AddCategoryDelegate {
    func addCategory(newCategory: Category)
}

class AddCategoryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextLabel: UITextField!
    @IBOutlet weak var colorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    var currentCategory: Category?
    var managedObjectContext: NSManagedObjectContext?
    var delegate: AddCategoryDelegate?
    
    @IBAction func chooseNewImageButton(_ sender: Any) {
        let controller = UIImagePickerController()
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            controller.sourceType = UIImagePickerControllerSourceType.camera
        }
        else {
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAllChangesButton(_ sender: Any) {
        let name: String = nameTextLabel.text!
        let color: String
        switch colorSegmentedControl.selectedSegmentIndex{
        case 0:
            color = "Red"
            break
        case 1:
            color = "Blue"
            break
        case 2:
            color = "Grey"
            break
        case 3:
            color = "Yellow"
            break
        case 4:
            color = "Green"
            break
        default:
            color = "Red"
            break
        }
        
        let imageData: NSData
//        if imageView.image != nil{
            imageData = (UIImagePNGRepresentation(imageView.image!) as NSData?)!
//        }
//        else{
//            //set default image
//            imageData = (UIImagePNGRepresentation(UIImage(named: "category_default_icon.jpg")!) as NSData?)!
//        }
        let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: self.managedObjectContext!) as! Category
        
        newCategory.name = name
        newCategory.color = color
        newCategory.icon = imageData
        newCategory.addToContainRestaurant(NSSet())
        
        do {
            try self.managedObjectContext!.save()
        } catch {
            print("cannot save \(error)")
        }
        
        self.delegate!.addCategory(newCategory: newCategory)
        self.navigationController!.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if currentCategory != nil{
            nameTextLabel.text = currentCategory!.name
            let currentColor: String = currentCategory!.color!
            switch currentColor{
            case "Red":
                colorSegmentedControl.selectedSegmentIndex = 0
                break
            case "Blue":
                colorSegmentedControl.selectedSegmentIndex = 1
                break
            case "Grey":
                colorSegmentedControl.selectedSegmentIndex = 2
                break
            case "Yellow":
                colorSegmentedControl.selectedSegmentIndex = 3
                break
            case "Green":
                colorSegmentedControl.selectedSegmentIndex = 4
                break
            default:
                colorSegmentedControl.selectedSegmentIndex = 0
                break
            }
            
            imageView.image = UIImage(data: (currentCategory!.icon!) as Data)
        }else{
            imageView.image = UIImage(named: "category_default_icon.jpg")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
