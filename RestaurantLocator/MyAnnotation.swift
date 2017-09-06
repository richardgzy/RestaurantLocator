//
//  MyAnnotation.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/9/4.
//  Copyright © 2017年 Richard. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var notificationRadius: Int16?
    var icon: UIImage?
    
    init(newTitle: String, newNotificationRadius: Int16, newIcon: UIImage, lat: Double, long: Double) {
        title = newTitle
        notificationRadius = newNotificationRadius
        icon = newIcon
        coordinate = CLLocationCoordinate2D()
        coordinate.latitude = lat
        coordinate.longitude = long
    }
}
