//
//  RecipeDetailViewModel.swift
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

protocol RecipeDetailViewModelDelegate {
    func refresh()
}

class RecipeDetailViewModel {
    /// Recipe to be edited
    private var recipe: Recipe?
    /// Fields to be shown in the table view
    private var fields: [FieldViewModel] = []
    /// Called to reload the table view data
    var refresh: (() -> Void)?
    /// Handle error in UI when an error happens
    var errorHandler: ((String) -> Void)?
    /// Delegate for notifying when a recipe is created or deleted
    var delegate: RecipeDetailViewModelDelegate?
    /// Image to be displayed in the image field
    var image: UIImage?
    /// Defines whether the image was changed or not
    @Published var imageDidChange: Bool = false
    /// Defined whether the user is editing an existing recipe or creating a new one
    var isEditing: Bool {
        return recipe != nil
    }
    /// Number of sections fo the table view
    var numberOfSections: Int {
        if isEditing {
            return RecipeDetailViewController.Section.allCases.count
        } else {
            return RecipeDetailViewController.Section.allCases.count - 1
        }
    }
    /// Title for the navigation bar
    var title: String {
        if let recipe = recipe {
            return recipe.name
        } else {
            return Localizable.Title.newRecipe
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
    
    init(recipe: Recipe? = nil) {
        self.recipe = recipe
        if let data = recipe?.imageData {
            image = UIImage(data: data)
        }
        setupFields()
    }
    
    /// Number of rows for a section
    /// - Parameter section: Section where the rows belong
    /// - Returns: Number of rows for a section
    func numberOfRows(in section: Int) -> Int {
        guard let section = RecipeDetailViewController.Section(rawValue: section) else { return 0 }
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
        if let recipe = recipe {
            availableCount = Int(recipe.availableCount)
        }
        let nameField = TextFieldCellViewModel(title: Localizable.Text.name, value: recipe?.name)
        nameField.validations = [.required]
        let priceField = CurrencyTextFieldCellViewModel(title: Localizable.Text.price, placeholder: "$0.00", value: recipe?.price)
        priceField.validations = [.required]
        let availabilityField = IntTextFieldCellViewModel(title: Localizable.Text.availableCount, value: availableCount)
        availabilityField.validations = [.required]
        fields = [
            nameField,
            priceField,
            availabilityField
        ]
    }
    
    /// Create a new recipe if `recipe` is nil or updates the current recipe otherwise
    func save() {
        guard let name = fields[0].stringValue else { return }
        guard let price = fields[1].stringValue?.doubleValue else { return }
        guard let availableCount = Int32(fields[2].stringValue ?? "0") else { return }
        var newRecipe: Recipe!
        if !name.isEmpty {
            if let recipe = recipe {
                newRecipe = recipe
            } else {
                newRecipe = Recipe(context: PersistenceController.shared.container.viewContext)
                newRecipe.dateCreated = Date()
            }
            newRecipe.name = name
            newRecipe.price = price
            newRecipe.availableCount = availableCount
            newRecipe.imageData = image?.jpegCompressedData
            imageDidChange = false
        }
        do {
            try PersistenceController.shared.saveContext()
            if recipe != nil {
                recipe = newRecipe
            }
            delegate?.refresh()
        } catch {
            errorHandler?(Localizable.Error.saveRecipe)
        }
    }
    
    /// Deletes the current recipe
    func delete() {
        if let recipe = recipe {
            MenuPersistenceManager.shared.delete(recipe)
            delegate?.refresh()
        }
    }
    
    /// Sets the recipe image to nil
    func clearImage() {
        image = nil
        imageDidChange = true
        do {
            try PersistenceController.shared.saveContext()
            refresh?()
            delegate?.refresh()
        } catch {
            errorHandler?(Localizable.Error.resetImage)
        }
    }
    
}
