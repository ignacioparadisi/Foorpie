//
//  CurrencyTextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CurrencyTextFieldCellViewModel: FieldViewModelRepresentable {
    var placeholder: String?
    var stringValue: String? {
        return "\(value)"
    }
    var title: String?
    private(set) var value: Double
    var type: FieldType {
        return .currency
    }
    
    init(title: String? = nil, placeholder: String? = nil, value: Double? = 0.0) {
        self.title = title
        self.placeholder = placeholder
        self.value = value ?? 0.0
    }
}
