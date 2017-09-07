//
//  mapViewController.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/9/6.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import CoreData 
import MapKit

class mapViewController: UIViewController, CLLocationManagerDelegate {
    var annotationList: [MyAnnotation] = []
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var categoryList: [NSManagedObject] = []
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var radiusSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 1
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        categoryList = appdelegate.categoryList as! [Category]
        
        //load all restaurant coordinates
        if categoryList.count != 0{
            for category in self.categoryList as! [Category] {
                let restaurantArray = category.containRestaurant?.allObjects as! [Restaurant]
                for restaurant in restaurantArray{
                    let image: UIImage = UIImage(data: (restaurant.logo!) as Data)!
                    let address = restaurant.address
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(address!) { (placemarks, error) in
                        guard
                            let placemarks = placemarks,
                            let location = placemarks.first?.location
                            else {
                                print("error finding location")
                                return
                            }
                    restaurant.latitude = location.coordinate.latitude
                    restaurant.longitude = location.coordinate.longitude
                        
                    let annotation: MyAnnotation = MyAnnotation(newTitle: restaurant.name!, newNotificationRadius: restaurant.notificationRadius, newIcon: image, lat: restaurant.latitude, long: restaurant.longitude)
                    self.annotationList.append(annotation)
                    self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
        
        radiusSelector.addTarget(self, action: Selector(("segmentedControlValueChanged:")), for:.valueChanged)
    }
    
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 50, 50)
            self.mapView.setRegion(mapRegion, animated: true)
            break
        case 1:
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 250, 250)
            self.mapView.setRegion(mapRegion, animated: true)
            break
        case 2:
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 500, 500)
            self.mapView.setRegion(mapRegion, animated: true)
            break
        case 3:
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 1000, 1000)
            self.mapView.setRegion(mapRegion, animated: true)
            break
        case 4:
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 2000, 2000)
            self.mapView.setRegion(mapRegion, animated: true)
            break
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        currentLocation = loc?.coordinate
        
        if(loc != nil) {
//            let userAnnotation = MKPointAnnotation()
//            userAnnotation.coordinate = currentLocation!
//            userAnnotation.title = "You are here"
//            mapView.addAnnotation(userAnnotation)
            mapView.showsUserLocation = true
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 2000, 2000)
            self.mapView.setRegion(mapRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert(title: "Welcome!", message: "You entered the region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(title: "ByeBye!", message: "You left the region")
    }
    
    func showAlert(title: String, message: String){
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        myAlert.addAction(myAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
