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
        super.init()
        self.type = .textField
        self.title = title
        self.placeholder = placeholder
        self.stringValue = value
    }
}
