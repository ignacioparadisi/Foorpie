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
    private var selectedIndexPath: IndexPath?
    var reloadData: (() -> Void)?
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
    
    func detailForRow(at indexPath: IndexPath? = nil) -> MenuItemDetailViewModel {
        selectedIndexPath = indexPath
        if let indexPath = indexPath {
            let item = filteredItems[indexPath.row]
            let viewModel = MenuItemDetailViewModel(item: item)
            viewModel.delegate = self
            return viewModel
        } else {
            let viewModel = MenuItemDetailViewModel()
            viewModel.delegate = self
            return viewModel
        }
        
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

extension MenuViewModel: MenuItemDetailViewModelDelegate {
    func refresh() {
        fetch()
        reloadData?()
    }
}
