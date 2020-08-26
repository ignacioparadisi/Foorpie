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
}

protocol FieldViewModelRepresentable {
    var placeholder: String? { get set }
    var stringValue: String? { get set }
    var title: String? { get set }
    var type: FieldType { get set }
    var isValid: Bool { get set }
    var validations: [ValidatorConvertible] { get set }
    var isChanged: Bool { get set }
}

class FieldViewModel: FieldViewModelRepresentable {
    var placeholder: String?
    var originalValue: String?
    var stringValue: String? {
        didSet {
            validate()
            isChanged = stringValue != originalValue
        }
    }
    var title: String?
    var type: FieldType = .textField
    @Published var isValid: Bool = false
    var validations: [ValidatorConvertible] = []
    @Published var isChanged: Bool = false
    
    init(title: String? = nil, placeholder: String? = nil, stringValue: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.stringValue = stringValue
        self.originalValue = stringValue
    }
    
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
