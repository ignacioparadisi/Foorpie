//
//  IntTextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class IntTextFieldCellViewModel: FieldViewModel {
    init(title: String? = nil, placeholder: String? = nil, value: Int? = nil) {
        var stringValue: String?
        if let value = value {
            stringValue = String(describing: value)
        }
        super.init(title: title, placeholder: placeholder, stringValue: stringValue)
        self.type = .integer
    }
}
