//
//  MenuFoodItem+CoreDataProperties.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension MenuFoodItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuFoodItem> {
        return NSFetchRequest<MenuFoodItem>(entityName: "MenuFoodItem")
    }

    @NSManaged public var dateCreated: Date
    @NSManaged public var position: Int16
    @NSManaged public var price: Float
    @NSManaged public var availableCount: Int32
    @NSManaged public var name: String
    @NSManaged public var imageURL: URL?

}
