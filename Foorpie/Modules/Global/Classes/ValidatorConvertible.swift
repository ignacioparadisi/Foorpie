//
//  ValidatorConvertible.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class ValidatorConvertible: Equatable {
    /// Required validator
    static var required = RequiredValidator(tag: "required")
    /// Tag for comparing validations
    var tag: String = ""
    init(tag: String) {
        self.tag = tag
    }
    /// Method for validating if the field is valid
    func validate(_ value: String?) throws -> String {
        fatalError("Method `validate` has to be overriden")
    }
    /// Compare tags to see if validators are equal
    static func == (lhs: ValidatorConvertible, rhs: ValidatorConvertible) -> Bool {
        return lhs.tag == rhs.tag
    }
}

class RequiredValidator: ValidatorConvertible {
    /// Verify if field is not empty
    override func validate(_ value: String?) throws -> String {
        guard let value = value, !value.isEmpty else { throw ValidatorError.required }
        return value
    }
}

enum ValidatorError: Error {
    case required
}
