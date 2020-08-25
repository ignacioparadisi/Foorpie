//
//  TextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class TextFieldCellViewModel: FieldViewModel {
    var placeholder: String?
    var stringValue: String?
    var title: String?
    var type: FieldType {
        return .textField
    }
    
    init(title: String? = nil, placeholder: String? = nil, value: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self.stringValue = value
    }
}
