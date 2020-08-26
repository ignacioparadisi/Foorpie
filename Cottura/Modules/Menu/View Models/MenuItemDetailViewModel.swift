//
//  MenuItemDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

protocol MenuItemDetailViewModelDelegate {
    func didCreateItem(item: MenuFoodItem)
}

class MenuItemDetailViewModel {
    private let item: MenuFoodItem?
    private var fields: [FieldViewModel] = []
    var delegate: MenuItemDetailViewModelDelegate?
    var image: UIImage?
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
        if let imageURL = item?.imageURL {
            image = UIImage(contentsOfFile: imageURL.path)
        }
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
    
    func fieldForRow(at indexPath: IndexPath) -> FieldViewModel {
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
    
    var fieldsAreValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(fields[0].$isValid, fields[1].$isValid, fields[2].$isValid)
            .map { $0 && $1 && $2}
            .eraseToAnyPublisher()
    }
    
    var fieldsAreChanged: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(fields[0].$isChanged, fields[1].$isChanged, fields[2].$isChanged)
            .map { $0 || $1 || $2}
            .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(fieldsAreValid, fieldsAreChanged)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func save() {
        guard let name = fields[0].stringValue else { return }
        guard let price = fields[1].stringValue?.currencyDoubleValue else { return }
        guard let availableCount = Int32(fields[2].stringValue ?? "0") else { return }
        var newItem: MenuFoodItem = MenuFoodItem(context: PersistenceController.shared.container.viewContext)
        if !name.isEmpty {
            if let item = item {
                newItem = item
            } else {
                newItem.dateCreated = Date()
            }
            newItem.name = name
            newItem.price = price
            newItem.availableCount = availableCount
            newItem.imageURL = saveImageLocally(name: name)
        }
        
        do {
            try PersistenceController.shared.saveContext()
            delegate?.didCreateItem(item: newItem)
        } catch {
            print("Error saving context")
        }
        
        
    }
    
    func saveImageLocally(name: String) -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        guard let imageName = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return nil }
        let imageURL = documentDirectory.appendingPathComponent("\(imageName).jpeg")
        guard let data = image?.jpegData(compressionQuality: 0.5) else { return nil }
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(atPath: imageURL.path)
            } catch {
                print("Error deleting image")
            }
        }
        
        do {
            try data.write(to: imageURL)
            return imageURL
        } catch {
            print("Error saving image")
        }
        return nil
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
