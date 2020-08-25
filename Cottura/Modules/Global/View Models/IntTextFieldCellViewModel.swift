//
//  IntTextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class IntTextFieldCellViewModel: FieldViewModelRepresentable {
    var placeholder: String?
    var stringValue: String?
    var title: String?
    var type: FieldType {
        return .integer
    }
    var value: Int?
    
    init(title: String? = nil, placeholder: String? = nil, value: Int? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.value = value
        if let value = value {
            self.stringValue = String(describing: value)
        }
    }
}
