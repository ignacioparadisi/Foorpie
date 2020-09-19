//
//  Ingredient+CoreDataProperties.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var unit: String
    @NSManaged public var unitCount: Int32
    @NSManaged public var dateCreated: Date
    @NSManaged public var recipe: Recipe?

}
