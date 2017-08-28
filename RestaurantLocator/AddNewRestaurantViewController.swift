//
//  AddNewRestaurantViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/26.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit

class AddNewRestaurantViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notificationRangeSegmentControl: UISegmentedControl!
    @IBOutlet weak var mediaSelectionButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var newLocationButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
