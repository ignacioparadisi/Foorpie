//
//  IngredientDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

protocol IngredientDetailViewModelDelegate: class {
    func refresh()
}

class IngredientDetailViewModel {
    
    enum Section: Int, CaseIterable {
        case fields
        case delete
    }
    
    // MARK: Properties
    weak var delegate: IngredientDetailViewModelDelegate?
    /// Handle error in UI when an error happens
    var errorHandler: ((String) -> Void)?
    private var ingredient: Ingredient?
    /// Fields to be shown in the table view
    private var fields: [FieldViewModel] = []
    var title: String {
        if let ingredient = ingredient {
            return ingredient.name
        }
        return "Nuevo Ingrediente"
    }
    var isEditing: Bool {
        return ingredient != nil
    }
    /// Number of sections fo the table view
    var numberOfSections: Int {
        if isEditing {
            return Section.allCases.count
        } else {
            return Section.allCases.count - 1
        }
    }
    /// Checks that the information of all fields are valid
    var fieldsAreValid: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(fields[0].$isValid, fields[1].$isValid, fields[2].$isValid, fields[3].$isValid)
            .map { $0 && $1 && $2 && $3 }
            .eraseToAnyPublisher()
    }
    /// Checks if the information of any field changed
    var fieldsAreChanged: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(fields[0].$isChanged, fields[1].$isChanged, fields[2].$isChanged, fields[3].$isChanged)
            .map { $0 || $1 || $2 || $3 }
            .eraseToAnyPublisher()
    }
    /// Defines if the form is ready to submit based on `fieldsAreValid` and `fieldsAreChanged`
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(fieldsAreValid, fieldsAreChanged)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    // MARK: Initializer
    init(ingredient: Ingredient? = nil) {
        self.ingredient = ingredient
        setupFields()
    }
    
    // MARK: Functions
    /// Creates all fields that will be shown in the table view
    private func setupFields() {
        let nameField = TextFieldCellViewModel(title: Localizable.Text.name, value: ingredient?.name)
        nameField.validations = [.required]
        let priceField = CurrencyTextFieldCellViewModel(title: Localizable.Text.price, placeholder: "$0.00", value: ingredient?.price)
        priceField.validations = [.required]
        let unitType = Ingredient.UnitType(rawValue: ingredient?.unitType ?? "u")
        let unitField = UnitTextFieldCellViewModel(title: "Unidad", value: Int(ingredient?.unitAmount ?? 0), unitType: unitType)
        unitField.validations = [.required]
//        let unitAmountField = FloatTextFieldCellViewModel(title: Localizable.Text.availableAmount, value: unitAmount)
//        unitAmountField.validations = [.required]
        fields = [
            nameField,
            priceField,
            unitField,
  //          unitAmountField
        ]
    }
    func section(for indexPath: IndexPath) -> Section? {
        return Section(rawValue: indexPath.section)
    }
    func numberOfRows(in section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .fields:
            return fields.count
        case .delete:
            return 1
        }
    }
    /// Field to be displayed at a specific row
    /// - Parameter indexPath: Index Path for the field
    /// - Returns: Field for the index path
    func fieldForRow(at indexPath: IndexPath) -> FieldViewModel {
        let field = fields[indexPath.row]
        return field
    }
    func save() {
        guard let name = fields[0].stringValue else { return }
        guard let price = fields[1].stringValue?.doubleValue else { return }
        guard let unitField = fields[2] as? UnitTextFieldCellViewModel else { return }
        guard let unitAmount = unitField.stringValue?.doubleValue else { return }
        guard let unit = unitField.unitType else { return }
        guard let availableAmount = fields[3].stringValue?.doubleValue else { return }
        var newIngredient: Ingredient!
        if !name.isEmpty {
            if let ingredient = ingredient {
                newIngredient = ingredient
            } else {
                newIngredient = Ingredient(context: PersistenceController.shared.container.viewContext)
            }
            newIngredient.name = name
            newIngredient.price = price
            newIngredient.unitAmount = unitAmount
            newIngredient.unitType = unit.rawValue
            newIngredient.availableAmount = availableAmount
        }
        if ingredient == nil {
            PersistenceManagerFactory.menuPersistenceManager.create(ingredient: newIngredient) { [weak self] result in
                switch result {
                case .success:
                    self?.delegate?.refresh()
                    print("Success")
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.errorHandler?(Localizable.Error.saveRecipe)
                }
            }
        } else {
            PersistenceManagerFactory.menuPersistenceManager.update(ingredient: newIngredient) { [weak self] result in
                switch result {
                case .success(let ingredient):
                    self?.ingredient = ingredient
                    self?.delegate?.refresh()
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.errorHandler?(Localizable.Error.saveRecipe)
                }
            }
        }
    }
}
