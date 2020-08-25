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
    private var fields: [FieldViewModelRepresentable] = []
    var isEditing: Bool {
        return item != nil
    }
    var numberOfSections: Int {
        if isEditing {
            return MenuItemDetailViewController.Section.allCases.count
        } else {
            return MenuItemDetailViewController.Section.allCases.count - 1
        }
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
        var availableCount: Int?
        if let item = item {
            availableCount = Int(item.availableCount)
        }
        fields = [
            TextFieldCellViewModel(title: "Nombre", value: item?.name),
            CurrencyTextFieldCellViewModel(title: "Precio", value: item?.price),
            IntTextFieldCellViewModel(title: "Cantidad Disponible", value: availableCount)
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
            return isEditing ? 1: 0
        }
    }
    
    func fieldForRow(at indexPath: IndexPath) -> FieldViewModelRepresentable {
       let field = fields[indexPath.row]
        return field
    }
}
