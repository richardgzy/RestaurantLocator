//
//  RestaurantDetailViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/23.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RestaurantDetailViewController: UIViewController {
    var currentRestaurant: Restaurant?
    
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var NavagationTitle: UINavigationItem!
//    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rangeSegmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.iconView.image = UIImage(data: (currentRestaurant?.logo!)! as Data)
        self.NavagationTitle.title = currentRestaurant!.name
        self.categoryLabel.text = currentRestaurant!.belongCategory?.name
//        self.ratingLabel.text = "Rating: \(currentRestaurant!.rating) Stars"
        self.ratingControl.setEditable(isEditable: false)
        self.ratingControl.setButtonSelected(numberOfStarsSelected: Int(currentRestaurant!.rating))
        self.addressTextView.text = currentRestaurant!.address
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "dd-mm-yyyy"
        self.dateLabel.text = "Added in: \(df.string(from: currentRestaurant!.addDate! as Date))"
        let range: Int16 = currentRestaurant!.notificationRadius
        switch range{
        case 0:
            self.rangeSegmentControl.selectedSegmentIndex = 0
            break
        case 50:
            self.rangeSegmentControl.selectedSegmentIndex = 1
            break
        case 250:
            self.rangeSegmentControl.selectedSegmentIndex = 2
            break
        case 500:
            self.rangeSegmentControl.selectedSegmentIndex = 3
            break
        case 1000:
            self.rangeSegmentControl.selectedSegmentIndex = 4
            break
        default:
            break
        }
        
        let image: UIImage = UIImage(data: (self.currentRestaurant?.logo!)! as Data)!
        
        let address = currentRestaurant?.address
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    let alert = UIAlertController(title: "Alert", message: "location not found", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
            }
            // Use your location
            
            let myAnnotation: MyAnnotation = MyAnnotation(newTitle: self.currentRestaurant!.name!, newNotificationRadius: (self.currentRestaurant?.notificationRadius)!, newIcon: image, lat: location.coordinate.latitude, long: location.coordinate.longitude)
            self.mapView.addAnnotation(myAnnotation)
            let mapRegion = MKCoordinateRegionMakeWithDistance(myAnnotation.coordinate, 500, 500)
            self.mapView.setRegion(mapRegion, animated: true)
        }
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
