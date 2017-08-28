//
//  Category+CoreDataProperties.swift
//  RestaurantLocator
//
//  Created by Richard on 2017/8/27.
//  Copyright © 2017年 Richard. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var color: String?
    @NSManaged public var icon: NSData?
    @NSManaged public var name: String?
    @NSManaged public var containRestaurant: NSSet?
    
    func addRestaurant(value: Restaurant)
    {
        let r = self.mutableSetValue(forKey: "containRestaurant")
        r.add(value)
    }
}

// MARK: Generated accessors for containRestaurant
extension Category {

    @objc(addContainRestaurantObject:)
    @NSManaged public func addToContainRestaurant(_ value: Restaurant)

    @objc(removeContainRestaurantObject:)
    @NSManaged public func removeFromContainRestaurant(_ value: Restaurant)

    @objc(addContainRestaurant:)
    @NSManaged public func addToContainRestaurant(_ values: NSSet)

    @objc(removeContainRestaurant:)
    @NSManaged public func removeFromContainRestaurant(_ values: NSSet)

}
