//
//  TextFieldCellViewModel.swift
//  Cottura
//
//  Created by Ignacio Paradisi on 8/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class TextFieldCellViewModel: FieldViewModel {
    init(title: String? = nil, placeholder: String? = nil, value: String? = nil) {
        super.init(title: title, placeholder: placeholder, stringValue: value)
        self.type = .textField
    }
}
