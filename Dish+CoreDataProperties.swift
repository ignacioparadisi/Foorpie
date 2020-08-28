//
//  Dish+CoreDataProperties.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish")
    }

    @NSManaged public var availableCount: Int32
    @NSManaged public var dateCreated: Date
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String
    @NSManaged public var price: Double

}
