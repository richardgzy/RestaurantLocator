//
//  Restaurant+CoreDataProperties.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/9/7.
//  Copyright © 2017年 Richard. All rights reserved.
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var addDate: NSDate?
    @NSManaged public var address: String?
    @NSManaged public var category: String?
    @NSManaged public var latitude: Double
    @NSManaged public var logo: NSData?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var notificationRadius: Int16
    @NSManaged public var rating: Int16
    @NSManaged public var id: Int64
    @NSManaged public var belongCategory: Category?

}
