//
//  MenuItemDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class MenuItemDetailViewModel {
    private let item: MenuFoodItem?
    private var fields: [FieldViewModel] = []
    @Published var image: UIImage?
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
        setupFields()
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
    
    func fieldForRow(at indexPath: IndexPath) -> FieldViewModel{
       let field = fields[indexPath.row]
        return field
    }
    
    private func setupFields() {
        var availableCount: Int?
        if let item = item {
            availableCount = Int(item.availableCount)
        }
        let nameField = TextFieldCellViewModel(title: "Nombre", value: item?.name)
        nameField.validations = [ValidatorFactory.validatorFor(type: .required)]
        let priceField = CurrencyTextFieldCellViewModel(title: "Precio", value: item?.price)
        priceField.validations = [ValidatorFactory.validatorFor(type: .required)]
        let availabilityField = IntTextFieldCellViewModel(title: "Cantidad Disponible", value: availableCount)
        availabilityField.validations = [ValidatorFactory.validatorFor(type: .required)]
        fields = [
            nameField,
            priceField,
            availabilityField
        ]
    }
    
    var readyToSubmit: AnyPublisher<Bool, Never> {
        // if fields.count < 3 { return Just(false).eraseToAnyPublisher() }
        return Publishers.CombineLatest3(fields[0].$isValid, fields[1].$isValid, fields[2].$isValid)
            .map { $0 && $1 && $2}
            .eraseToAnyPublisher()
    }
}

protocol ValidatorConvertible {
    func validate(_ value: String?) throws -> String
}

enum ValidatorType {
    case required
}

enum ValidatorFactory {
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .required: return RequiredValidator()
        }
    }
}

class RequiredValidator: ValidatorConvertible {
    func validate(_ value: String?) throws -> String {
        guard let value = value, !value.isEmpty else { throw ValidatorError.required }
        return value
    }
}

enum ValidatorError: Error {
    case required
}
