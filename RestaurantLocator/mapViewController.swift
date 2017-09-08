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
    var allRestaurants: [Restaurant] = []
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var categoryList: [Category] = []

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func userRadiusChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 1
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        categoryList = appdelegate.categoryList!
        
        //load all restaurant coordinates
        if categoryList.count != 0{
            for category in self.categoryList {
                let restaurantArray = category.containRestaurant?.allObjects as! [Restaurant]
                showRestaurantAnnotationOnMapView(restaurantArray: restaurantArray, range: Double.infinity)
            }
        }
    }
    
    func showRestaurantAnnotationOnMapView(restaurantArray: [Restaurant], range: Double){
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
                self.allRestaurants.append(restaurant)
                self.mapView.addAnnotation(annotation)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last
        currentLocation = loc?.coordinate
        let userPosition = CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude)
        
        
        if(loc != nil) {
//            let userAnnotation = MKPointAnnotation()
//            userAnnotation.coordinate = currentLocation!
//            userAnnotation.title = "You are here"
//            mapView.addAnnotation(userAnnotation)
            mapView.showsUserLocation = true
            let mapRegion = MKCoordinateRegionMakeWithDistance(currentLocation!, 2000, 2000)
            self.mapView.setRegion(mapRegion, animated: true)
        }
        
        //geofencing
        var userEnteredRestaurantArea = [String : Bool]()
        
        if allRestaurants.count != 0{
            
            for r in allRestaurants{
                let restaurantPosition = CLLocation(latitude: r.latitude, longitude: r.longitude)
                if restaurantPosition.distance(from: userPosition) <= Double(r.notificationRadius){
                    showAlert(title: "Welcome!", message: "Welcome to \(r.name!)")
                    userEnteredRestaurantArea[r.name!] = true
                } else {
                    userEnteredRestaurantArea[r.name!] = false
                }
            }
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
