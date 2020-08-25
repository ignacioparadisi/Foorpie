//
//  MenuItemDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

class MenuItemDetailViewModel {
    private let item: MenuFoodItem?
    private var fields: [FieldViewModel] = []
    var numberOfSections: Int {
        return MenuItemDetailViewController.Section.allCases.count
    }
    var title: String {
        if let item = item {
            return item.name
        } else {
            return "Nuevo Artículo"
        }
    }
    
    init(item: MenuFoodItem? = nil) {
        self.item = item
        fields = [
            TextFieldCellViewModel(title: "Nombre", value: item?.name)
        ]
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = MenuItemDetailViewController.Section(rawValue: section) else { return 0 }
        switch section {
        case .photo:
            return 1
        case .fields:
            return fields.count
        case .delete:
            return 1
        }
    }
    
    func fieldForRow<T: FieldViewModel>(at indexPath: IndexPath) -> T {
        guard let field = fields[indexPath.row] as? T else {
            fatalError("Could not cast field \(String(describing: fields[indexPath.row].title))")
        }
        return field
    }
}
