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
        // Unit
        case unit
        // Weight
        case pound
        case kilogram
        case gram
        case milligram
        // Volume
        case gallon
        case liter
        case milliliter
        // Weight and Volume
        case ounce
        // Length
        case meters
        case centimeters
        case feet
        case inch
        
        var abbreviatedText: String {
            switch self {
            case .kilogram:
                return "kg"
            case .gram:
                return "gr"
            case .milligram:
                return "mg"
            case .pound:
                return "lb"
            case .ounce:
                return "oz"
            case .liter:
                return "l"
            case .milliliter:
                return "ml"
            case .gallon:
                return "gal"
            case .meters:
                return "m"
            case .centimeters:
                return "cm"
            case .feet:
                return "ft"
            case .inch:
                return "in"
            case .unit:
                return "u"
            }
        }
        
        var text: String {
            switch self {
            case .kilogram:
                return Localizable.Text.kilogram
            case .gram:
                return Localizable.Text.gram
            case .milligram:
                return Localizable.Text.milligram
            case .pound:
                return Localizable.Text.pound
            case .ounce:
                return Localizable.Text.ounce
            case .liter:
                return Localizable.Text.liter
            case .milliliter:
                return Localizable.Text.milliliter
            case .gallon:
                return Localizable.Text.gallon
            case .meters:
                return Localizable.Text.meters
            case .centimeters:
                return Localizable.Text.centimeters
            case .feet:
                return Localizable.Text.feet
            case .inch:
                return Localizable.Text.inch
            case .unit:
                return Localizable.Text.unit
            }
        }
    }
    
}
