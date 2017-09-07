//
//  AddNewRestaurantViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/26.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData

class AddNewRestaurantViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notificationRangeSegmentControl: UISegmentedControl!
    @IBOutlet weak var mediaSelectionButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var newLocationButton: UIButton!
    
    var currentRestaurant: Restaurant?
    var categoryList: NSMutableArray?
    var categoryNameList = ["category 1", "category 2"]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.text = currentRestaurant!.name
        var categoryNameList = [String]()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryNameList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryNameList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
