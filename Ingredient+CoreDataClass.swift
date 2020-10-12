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
    
//    required convenience init(name: String) {
//        self.init(context: PersistenceController.shared.container.viewContext)
//        self.name = name
//    }
//
//    required convenience init(_ ingredient: Ingredient) {
//        self.init(context: PersistenceController.shared.container.viewContext)
//        self.name = ingredient.name
//        self.price = ingredient.price
//        self.availableAmount = ingredient.availableAmount
//        self.unitType = ingredient.unitType
//        self.unitAmount = ingredient.unitAmount
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        do {
//            try container.encode(name, forKey: .name)
//            try container.encode(availableAmount, forKey: .availableAmount)
//            try container.encode(price, forKey: .price)
//            try container.encode(unitAmount, forKey: .unitAmount)
//            try container.encode(unitType, forKey: .unitType)
//            try container.encode(dateCreated, forKey: .dateCreated)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//    // MARK: Initializers
//    /// Initializer for the Decodable protocol
//    required public convenience init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "managedObjectContext"), // CodingUserInfoKey.managedObjectContext,
//            let context = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
//            let entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: context) else {
//                fatalError("Failed to decode Ingredient")
//        }
//        self.init(entity: entity, insertInto: context)
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
//        self.availableAmount = try container.decodeIfPresent(Double.self, forKey: .availableAmount) ?? 0
//        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0
//        self.unitAmount = try container.decodeIfPresent(Double.self, forKey: .unitAmount) ?? 0
//        self.unitType = try container.decodeIfPresent(String.self, forKey: .unitType) ?? ""
//        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case availableAmount
//        case dateCreated
//        case name
//        case price
//        case unitAmount
//        case unitType
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
//}
//
//enum EncodingError: Error {
//  case invalidData
//}
//
//extension Ingredient: NSItemProviderReading {
//    // 1
//    public static var readableTypeIdentifiersForItemProvider: [String] {
//        return [ingredientTypeIdentifier,
//                kUTTypePlainText as String]
//    }
//    // 2
//    public static func object(withItemProviderData data: Data,
//                              typeIdentifier: String) throws -> Self {
//        if typeIdentifier == kUTTypePlainText as String {
//            // 3
//            guard let name = String(data: data, encoding: .utf8) else {
//                throw EncodingError.invalidData
//            }
//            return self.init(
//                name: name)
//        } else if typeIdentifier == ingredientTypeIdentifier {
//            do {
//                let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
//                guard let ingredient =
//                        try unarchiver.decodeTopLevelDecodable(
//                            Ingredient.self, forKey: NSKeyedArchiveRootObjectKey) else {
//                    throw EncodingError.invalidData
//                }
//                return self.init(ingredient)
//            } catch {
//                throw EncodingError.invalidData
//            }
//        } else {
//            throw EncodingError.invalidData
//        }
//    }
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
                return LocalizedStrings.Text.kilogram
            case .gram:
                return LocalizedStrings.Text.gram
            case .milligram:
                return LocalizedStrings.Text.milligram
            case .pound:
                return LocalizedStrings.Text.pound
            case .ounce:
                return LocalizedStrings.Text.ounce
            case .liter:
                return LocalizedStrings.Text.liter
            case .milliliter:
                return LocalizedStrings.Text.milliliter
            case .gallon:
                return LocalizedStrings.Text.gallon
            case .meters:
                return LocalizedStrings.Text.meters
            case .centimeters:
                return LocalizedStrings.Text.centimeters
            case .feet:
                return LocalizedStrings.Text.feet
            case .inch:
                return LocalizedStrings.Text.inch
            case .unit:
                return LocalizedStrings.Text.unit
            }
        }
    }
}
