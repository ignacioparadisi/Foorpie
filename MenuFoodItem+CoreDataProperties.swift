//
//  MenuFoodItem+CoreDataProperties.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension MenuFoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuFoodItem> {
        return NSFetchRequest<MenuFoodItem>(entityName: "MenuFoodItem")
    }

    @NSManaged public var availableCount: Int32
    @NSManaged public var dateCreated: Date
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String
    @NSManaged public var price: Double

}
