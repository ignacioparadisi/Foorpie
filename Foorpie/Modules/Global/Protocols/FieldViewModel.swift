//
//  FieldViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum FieldType {
    case textField
    case currency
    case integer
    case unit
}

protocol FieldViewModelRepresentable {
    /// Placeholder to be added to the field
    var placeholder: String? { get set }
    /// Value for text field as String
    var stringValue: String? { get set }
    /// Title for field label
    var title: String? { get set }
    /// Type of field
    var type: FieldType { get set }
    /// Whether the field is valid or not depending on its validations
    var isValid: Bool { get set }
    /// Validations to be added to the field
    var validations: [ValidatorConvertible] { get set }
    /// Whether the value changed or not
    var isChanged: Bool { get set }
}

class FieldViewModel: FieldViewModelRepresentable {
    // MARK: Properties
    @Published var isValid: Bool = true
    @Published var isChanged: Bool = false
    var placeholder: String?
    /// Original value of the field to be compared to `stringValue` and see if it changed.
    var originalValue: String?
    var stringValue: String? {
        didSet {
            validate()
            isChanged = stringValue != originalValue
        }
    }
    var title: String?
    var type: FieldType = .textField
    var validations: [ValidatorConvertible] = []
    
    // MARK: Initializers
    init(title: String? = nil, placeholder: String? = nil, stringValue: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.stringValue = stringValue
        self.originalValue = stringValue
    }
    
    // MARK: Functions
    /// Verifies if the value in the textfield is valid or not
    func validate() {
        for validation in validations {
            do {
                _ = try validation.validate(stringValue)
            } catch {
                isValid = false
                return
            }
        }
        isValid = true
    }
}
