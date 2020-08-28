//
//  MenuPersistenceManager.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class MenuPersistenceManager {
    static var shared: MenuPersistenceManager = MenuPersistenceManager()
    
    private init() {}
    
    func fetch() -> Result<[Dish], Error> {
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Dish.name), ascending: true)]
        do {
            let result = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    func delete(_ dish: Dish) {
        PersistenceController.shared.container.viewContext.delete(dish)
    }
}
