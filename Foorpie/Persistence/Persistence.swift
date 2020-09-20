//
//  Persistence.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared: PersistenceController = {
        #if DEVELOPMENT
        let controller = PersistenceController(inMemory: true)
        controller.importMenuFromJSON(context: controller.container.viewContext)
        return controller
        #else
        return PersistenceController()
        #endif
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Foorpie")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext() throws {
        try container.viewContext.save()
    }
    
    fileprivate func importMenuFromJSON(context: NSManagedObjectContext) {
//        let jsonURL = Bundle.main.url(forResource: "ingredients-data", withExtension: "json")!
//        let jsonData = try! Data(contentsOf: jsonURL)
//        
//        let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]
//        
//        for jsonDictionary in jsonArray {
//            let ingredient = Ingredient(context: container.viewContext)
//            ingredient.name = jsonDictionary["name"] as! String
//            ingredient.price = jsonDictionary["price"] as! Double
//            ingredient.unitCount = jsonDictionary["unitCount"] as! Double
//            ingredient.unit = jsonDictionary["unit"] as! Int16
//            ingredient.dateCreated = Date()
//        }
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}

