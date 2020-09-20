//
//  FloatTextFieldCellViewModel.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 9/20/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class FloatTextFieldCellViewModel: FieldViewModel {
    init(title: String? = nil, placeholder: String? = nil, value: Double? = nil) {
        var stringValue: String?
        if let value = value {
            stringValue = String(describing: value)
        }
        super.init(title: title, placeholder: placeholder, stringValue: stringValue)
        self.type = .float
    }
}
