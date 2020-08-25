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
    private var filteredItems: [MenuFoodItem] = []
    private var filteredText: String?
    var numberOfSections: Int {
        return 1
    }
    
    // MARK: Functions
    func fetch() {
        let result = MenuPersistenceManager.shared.fetch()
        switch result {
        case .success(let items):
            self.items = items
            self.filteredItems = items
        case .failure(let error):
            print(error)
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return filteredItems.count
    }
    
    func itemForRow(at indexPath: IndexPath) -> MenuItemViewModel {
        return MenuItemViewModel(item: filteredItems[indexPath.row])
    }
    
    func deleteItem(at indexPath: IndexPath) {
        MenuPersistenceManager.shared.delete(item: filteredItems[indexPath.row])
        filteredItems.remove(at: indexPath.row)
    }
    
    func detailForRow(at indexPath: IndexPath) -> MenuItemDetailViewModel {
        let item = filteredItems[indexPath.row]
        return MenuItemDetailViewModel(item: item)
    }
    
    func filter(_ text: String?) {
        filteredText = text
        if let text = text, text != "" {
            filteredItems = items.filter {
                $0.name.lowercased().contains(text.lowercased())
            }
        } else {
            filteredItems = items
        }
    }
}
