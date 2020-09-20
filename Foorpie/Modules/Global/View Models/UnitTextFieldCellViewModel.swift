//
//  UnitTextFieldCellViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class UnitTextFieldCellViewModel: FieldViewModel {
    private var originalUnitType: Ingredient.UnitType?
    var unitType: Ingredient.UnitType? {
        didSet {
            valueDidChange()
        }
    }
    override var stringValue: String? {
        didSet {
            valueDidChange()
        }
    }
    init(title: String? = nil, placeholder: String? = nil, value: Int? = nil, unitType: Ingredient.UnitType? = nil) {
        var stringValue: String?
        if let value = value {
            stringValue = String(describing: value)
        }
        super.init(title: title, placeholder: placeholder, stringValue: stringValue)
        self.type = .unit
        self.unitType = unitType
        self.originalUnitType = unitType
    }
    func valueDidChange() {
        validate()
        isChanged = stringValue != originalValue || unitType != originalUnitType
    }
}
