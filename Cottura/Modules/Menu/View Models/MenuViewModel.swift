//
//  MenuViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/24/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class MenuViewModel {
    // MARK: Properties
    private var items: [MenuFoodItem] = []
    var numberOfSections: Int {
        return 1
    }
    
    // MARK: Functions
    func fetch() {
        let result = MenuPersistenceManager.shared.fetch()
        switch result {
        case .success(let items):
            self.items = items
        case .failure(let error):
            print(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return items.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> MenuItemViewModel {
        return MenuItemViewModel(item: items[indexPath.row])
    }
    
    func deleteItem(at indexPath: IndexPath) {
        MenuPersistenceManager.shared.delete(item: items[indexPath.row])
        items.remove(at: indexPath.row)
    }
    
    func moveItems(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let movedItem = items[sourceIndexPath.row]
        items.remove(at: sourceIndexPath.row)
        items.insert(movedItem, at: destinationIndexPath.row)
        for (index, item) in items.enumerated() {
            item.position = Int16(index)
        }
    }
    
}
