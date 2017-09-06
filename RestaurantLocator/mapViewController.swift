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

class mapViewController: UIViewController {
    var annotationList: NSMutableArray = []
//    var managedObjectContext: NSManagedObjectContext
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
