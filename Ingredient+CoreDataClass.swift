//
//  Ingredient+CoreDataClass.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Ingredient)
public class Ingredient: NSManagedObject {

    enum UnitType: Int, CaseIterable {
        // Weight
        case kilogram
        case gram
        case milligram
        case pound
        // Weight and Volume
        case ounce
        // Volume
        case liter
        case milliliter
        case gallon
        // Length
        case meters
        case centimeters
        case feet
        case inch
        // Unit
        case unit
    }
    
}
