//
//  MenuItemDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

enum SaveImageError: Error {
    case invalidPath(String)
    case nameToURLFormat
    case jpegConversion
    case invalidSelf
}

protocol MenuItemDetailViewModelDelegate {
    func refresh()
}

class MenuItemDetailViewModel {
    private var item: MenuFoodItem?
    private var fields: [FieldViewModel] = []
    var refresh: (() -> Void)?
    var delegate: MenuItemDetailViewModelDelegate?
    var image: UIImage?
    @Published var imageDidChange: Bool = false
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
        if let data = item?.imageData {
            image = UIImage(data: data)
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
        nameField.validations = [.required]
        let priceField = CurrencyTextFieldCellViewModel(title: "Precio", placeholder: "$0.00", value: item?.price)
        priceField.validations = [.required]
        let availabilityField = IntTextFieldCellViewModel(title: "Cantidad Disponible", value: availableCount)
        availabilityField.validations = [.required]
        fields = [
            nameField,
            priceField,
            availabilityField
        ]
    }
    
    var fieldsAreValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(fields[0].$isValid, fields[1].$isValid, fields[2].$isValid)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
    
    var fieldsAreChanged: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(fields[0].$isChanged, fields[1].$isChanged, fields[2].$isChanged, $imageDidChange)
            .map { name, price, availability, image in
                return name || price || availability || image
            }
            .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(fieldsAreValid, fieldsAreChanged)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func save() {
        guard let name = fields[0].stringValue else { return }
        guard let price = fields[1].stringValue?.doubleValue else { return }
        guard let availableCount = Int32(fields[2].stringValue ?? "0") else { return }
        var newItem: MenuFoodItem!
        if !name.isEmpty {
            if let item = item {
                newItem = item
            } else {
                newItem = MenuFoodItem(context: PersistenceController.shared.container.viewContext)
                newItem.dateCreated = Date()
            }
            newItem.name = name
            newItem.price = price
            newItem.availableCount = availableCount
            newItem.imageData = image?.jpegCompressedData
            imageDidChange = false
        }
        
        do {
            try PersistenceController.shared.saveContext()
            if item != nil {
                item = newItem
            }
            delegate?.refresh()
        } catch {
            print("Error saving context")
        }
    }
    
    func delete() {
        if let item = item {
            PersistenceController.shared.container.viewContext.delete(item)
            delegate?.refresh()
        }
    }
    
    func clearImage() {
        image = nil
        imageDidChange = true
        do {
            try PersistenceController.shared.saveContext()
            refresh?()
            delegate?.refresh()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}

class ValidatorConvertible: Equatable {
    static var required = RequiredValidator(tag: "required")
    var tag: String = ""
    init(tag: String) {
        self.tag = tag
    }
    func validate(_ value: String?) throws -> String {
        fatalError("Method `validate` has to be overriden")
    }
    static func == (lhs: ValidatorConvertible, rhs: ValidatorConvertible) -> Bool {
        return lhs.tag == rhs.tag
    }
}

class RequiredValidator: ValidatorConvertible {
    override func validate(_ value: String?) throws -> String {
        guard let value = value, !value.isEmpty else { throw ValidatorError.required }
        return value
    }
}

enum ValidatorError: Error {
    case required
}
