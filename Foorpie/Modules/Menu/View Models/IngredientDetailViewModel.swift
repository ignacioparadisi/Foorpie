//
//  IngredientDetailViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class IngredientDetailViewModel {
    
    enum Section: Int, CaseIterable {
        case fields
        case delete
    }
    
    // MARK: Properties
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
    
    // MARK: Initializer
    init(ingredient: Ingredient? = nil) {
        self.ingredient = ingredient
        setupFields()
    }
    
    // MARK: Functions
    /// Creates all fields that will be shown in the table view
    private func setupFields() {
        var unitAmount: Double?
        if let ingredient = ingredient {
            unitAmount = ingredient.availableAmount
        }
        let nameField = TextFieldCellViewModel(title: Localizable.Text.name, value: ingredient?.name)
        nameField.validations = [.required]
        let priceField = CurrencyTextFieldCellViewModel(title: Localizable.Text.price, placeholder: "$0.00", value: ingredient?.price)
        priceField.validations = [.required]
        let unitField = UnitTextFieldCellViewModel(title: "Unidad", value: Int(ingredient?.unitAmount ?? 0), unitType: nil)
        unitField.validations = [.required]
        let unitAmountField = FloatTextFieldCellViewModel(title: Localizable.Text.availableAmount, value: unitAmount)
        unitAmountField.validations = [.required]
        fields = [
            nameField,
            priceField,
            unitField,
            unitAmountField
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
        
    }
}
