//
//  DishDetailViewModel.swift
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

protocol DishDetailViewModelDelegate {
    func refresh()
}

class DishDetailViewModel {
    /// Dish to be edited
    private var dish: Dish?
    /// Fields to be shown in the table view
    private var fields: [FieldViewModel] = []
    /// Called to reload the table view data
    var refresh: (() -> Void)?
    /// Delegate for notifying when a dish is created or deleted
    var delegate: DishDetailViewModelDelegate?
    /// Image to be displayed in the image field
    var image: UIImage?
    /// Defines whether the image was changed or not
    @Published var imageDidChange: Bool = false
    /// Defined whether the user is editing an existing dish or creating a new one
    var isEditing: Bool {
        return dish != nil
    }
    /// Number of sections fo the table view
    var numberOfSections: Int {
        if isEditing {
            return DishDetailViewController.Section.allCases.count
        } else {
            return DishDetailViewController.Section.allCases.count - 1
        }
    }
    /// Title for the navigation bar
    var title: String {
        if let dish = dish {
            return dish.name
        } else {
            return "Nuevo Artículo"
        }
    }
    /// Checks that the information of all fields are valid
    var fieldsAreValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest3(fields[0].$isValid, fields[1].$isValid, fields[2].$isValid)
            .map { $0 && $1 && $2 }
            .eraseToAnyPublisher()
    }
    /// Checks if the information of any field changed
    var fieldsAreChanged: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(fields[0].$isChanged, fields[1].$isChanged, fields[2].$isChanged, $imageDidChange)
            .map { name, price, availability, image in
                return name || price || availability || image
            }
            .eraseToAnyPublisher()
    }
    /// Defines if the form is ready to submit based on `fieldsAreValid` and `fieldsAreChanged`
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(fieldsAreValid, fieldsAreChanged)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    init(dish: Dish? = nil) {
        self.dish = dish
        if let data = dish?.imageData {
            image = UIImage(data: data)
        }
        setupFields()
    }
    
    /// Number of rows for a section
    /// - Parameter section: Section where the rows belong
    /// - Returns: Number of rows for a section
    func numberOfRows(in section: Int) -> Int {
        guard let section = DishDetailViewController.Section(rawValue: section) else { return 0 }
        switch section {
        case .photo:
            return 1
        case .fields:
            return fields.count
        case .delete:
            return isEditing ? 1: 0
        }
    }
    
    /// Field to be displayed at a specific row
    /// - Parameter indexPath: Index Path for the field
    /// - Returns: Field for the index path
    func fieldForRow(at indexPath: IndexPath) -> FieldViewModel {
        let field = fields[indexPath.row]
        return field
    }
    
    /// Creates all fields that will be shown in the table view
    private func setupFields() {
        var availableCount: Int?
        if let dish = dish {
            availableCount = Int(dish.availableCount)
        }
        let nameField = TextFieldCellViewModel(title: "Nombre", value: dish?.name)
        nameField.validations = [.required]
        let priceField = CurrencyTextFieldCellViewModel(title: "Precio", placeholder: "$0.00", value: dish?.price)
        priceField.validations = [.required]
        let availabilityField = IntTextFieldCellViewModel(title: "Cantidad Disponible", value: availableCount)
        availabilityField.validations = [.required]
        fields = [
            nameField,
            priceField,
            availabilityField
        ]
    }
    
    /// Create a new dish if `dish` is nil or updates the current dish oherwise
    func save() {
        guard let name = fields[0].stringValue else { return }
        guard let price = fields[1].stringValue?.doubleValue else { return }
        guard let availableCount = Int32(fields[2].stringValue ?? "0") else { return }
        var newDish: Dish!
        if !name.isEmpty {
            if let dish = dish {
                newDish = dish
            } else {
                newDish = Dish(context: PersistenceController.shared.container.viewContext)
                newDish.dateCreated = Date()
            }
            newDish.name = name
            newDish.price = price
            newDish.availableCount = availableCount
            newDish.imageData = image?.jpegCompressedData
            imageDidChange = false
        }
        do {
            try PersistenceController.shared.saveContext()
            if dish != nil {
                dish = newDish
            }
            delegate?.refresh()
        } catch {
            print("Error saving context")
        }
    }
    
    /// Deletes the current dish
    func delete() {
        if let dish = dish {
            MenuPersistenceManager.shared.delete(dish)
            delegate?.refresh()
        }
    }
    
    /// Sets the dish image to nil
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
