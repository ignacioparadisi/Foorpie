//
//  CurrencyTextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

class CurrencyTextFieldCellViewModel: FieldViewModel {
    let value: Double?
    init(title: String? = nil, placeholder: String? = nil, value: Double? = 0.0) {
        self.value = value
        var stringValue: String?
        if let value = value {
            stringValue = String(describing: value)
        }
        super.init(title: title, placeholder: placeholder, stringValue: stringValue)
        self.type = .currency
    }
}
