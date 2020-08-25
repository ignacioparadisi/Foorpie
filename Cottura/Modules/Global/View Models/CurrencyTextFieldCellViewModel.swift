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
    var value: Double

    init(title: String? = nil, placeholder: String? = nil, value: Double? = 0.0) {
        self.value = value ?? 0.0
        super.init()
        self.type = .currency
        self.title = title
        self.placeholder = placeholder
        if let value = value {
            self.stringValue = String(describing: value)
        }
    }
}
