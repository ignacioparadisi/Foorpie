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
}

extension FieldViewModelRepresentable {
    
}

class FieldViewModel: FieldViewModelRepresentable {
    var placeholder: String?
    var stringValue: String? {
        didSet {
            validate()
        }
    }
    var title: String?
    var type: FieldType = .textField
    @Published var isValid: Bool = false
    var validations: [ValidatorConvertible] = []
    
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
