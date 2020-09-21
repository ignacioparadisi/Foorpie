//
//  Ingredient+CoreDataProperties.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var availableAmount: Double
    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var unitAmount: Double
    @NSManaged public var unitType: String?
    @NSManaged public var uuid: UUID
    @NSManaged public var recipe: Recipe?

}

extension Ingredient : Identifiable {

}
