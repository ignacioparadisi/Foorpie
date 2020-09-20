//
//  Ingredient+CoreDataClass.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData
import MobileCoreServices

var ingredientTypeIdentifier = "com.ignacioparadisi.Foorpie.Ingredient"

@objc(Ingredient)
public class Ingredient: NSManagedObject {
    
    // MARK: Initializers
    /// Initializer for the Decodable protocol
//    required public convenience init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey.managedObjectContext,
//            let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
//            let entity = NSEntityDescription.entity(forEntityName: "InspectionPointAI", in: context) else {
//                fatalError("Failed to decode InspectionPointAI")
//        }
//        self.init(entity: entity, insertInto: context)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.question = try container.decodeIfPresent(String.self, forKey: .question)
//        self.fieldId = try container.decodeIfPresent(Int32.self, forKey: .fieldId) ?? 0
//        self.information = try container.decodeIfPresent(String.self, forKey: .information)
//        self.type = try container.decodeIfPresent(String.self, forKey: .type)
//        self.order = try container.decodeIfPresent(Int32.self, forKey: .order) ?? 0
//        self.whoActiveRepair = try container.decodeIfPresent(Int32.self, forKey: .whoActiveRepair) ?? 0
//        self.offenderType = try container.decodeIfPresent(String.self, forKey: .offenderType)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case availableAmount
//        case dateCreated
//        case name
//        case price
//        case unitAmount
//        case unitType
//        case recipe
//    }
    
}

//extension Ingredient: NSItemProviderWriting {
//    public static var writableTypeIdentifiersForItemProvider: [String] {
//        return [ingredientTypeIdentifier, kUTTypePlainText as String]
//    }
//    
//    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        if typeIdentifier == kUTTypePlainText as String {
//            completionHandler(name.data(using: .utf8), nil)
//        } else if typeIdentifier == ingredientTypeIdentifier {
//            do {
//                let archiver = NSKeyedArchiver(requiringSecureCoding: false)
//                try archiver.encodeEncodable(self, forKey: NSKeyedArchiveRootObjectKey)
//                archiver.finishEncoding()
//                let data = archiver.encodedData
//                
//                completionHandler(data, nil)
//              } catch {
//                completionHandler(nil, nil)
//              }
//        }
//        return nil
//    }
//    
//    
//}

extension Ingredient {
    enum UnitType: String, CaseIterable {
        // Unit
        case unit = "u"
        // Weight
        case pound = "lb"
        case kilogram = "kg"
        case gram = "gr"
        case milligram = "mg"
        // Volume
        case gallon = "gal"
        case liter = "l"
        case milliliter = "ml"
        // Weight and Volume
        case ounce = "oz"
        // Length
        case meters = "m"
        case centimeters = "cm"
        case feet = "ft"
        case inch = "in"
        
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
