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
    private var items: [MenuItemViewModel] = [] {
        didSet {
            dataDidChange?()
        }
    }
    var dataDidChange: (() -> Void)?
    var numberOfSections: Int {
        return 1
    }
    
    // MARK: Functions
    func fetch() {
        items = [
            MenuItemViewModel(),
            MenuItemViewModel(),
            MenuItemViewModel()
        ]
    }
    func numberOfRows(in section: Int) -> Int {
        return items.count
    }
    func itemForRow(at indexPath: IndexPath) -> MenuItemViewModel {
        return items[indexPath.row]
    }
    
}
