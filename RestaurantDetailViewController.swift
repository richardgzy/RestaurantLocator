//
//  RestaurantDetailViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    var currentRestaurant: Restaurant?
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var NavagationTitle: UINavigationItem!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var rangeSegmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.iconView.image = currentRestaurant!.logo as? UIImage
        self.NavagationTitle.title = currentRestaurant!.name
        self.categoryLabel.text = currentRestaurant!.category
        self.ratingLabel.text = "Rating: \(currentRestaurant!.rating) Stars"
        self.dateLabel.text = "Added in: \(currentRestaurant!.addDate)"
        
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
